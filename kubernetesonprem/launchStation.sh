# Parameters
ARGO_NAMESPACE="argocd"
ROOT_TOKEN_VAULT="token123"

# Repo helm chart
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install argocd - Mot de passe argocd123 (bcrypt hash)
# You have to install ingress-nginx , we use minikube
# so we don't need
helm upgrade --install argocd argo/argo-cd --set server.ingress.enabled=true \
    --set server.ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/force-ssl-redirect"="true" \
    --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/backend-protocol"="HTTPS" \
    --set configs.secret.argocdServerAdminPassword='$2y$10$8LaHsCQS1hd74MIYj4jinuVni14FBL4PlDJ0SKAg9f/pQvolxVlRS' \
    --set configs.secret.argocdServerAdminPasswordMtime="2023-10-01T10:11:12Z" \
    --set server.ingress.hosts[0]="argocd.exakaconsulting.org" -n ${ARGO_NAMESPACE} --create-namespace

# Install shared
helm upgrade --install shared ./argocd/shared \
    --set vault.devRootToken="${ROOT_TOKEN_VAULT}"

# Wait for vault - to initialise it
argocd --core app wait vault
argocd --core app wait falco
argocd --core app wait prometheus

# Initialise ingress
kubectl apply -f ingress/vault-ing.yaml
kubectl apply -f ingress/falco-ing.yaml
kubectl apply -f ingress/prometheus-ing.yaml

# Install service monitor
kubectl apply -f cadvisor_sm.yaml

RESULT_VAULT_SECRETS=$( kubectl get secret -n stationdev | grep vault-secret | wc -l)
echo "Result Vault Secrets : ${RESULT_VAULT_SECRETS}"
if [[ "${RESULT_VAULT_SECRETS}" -eq 0 ]]; then
    # Login to vault
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault login ${ROOT_TOKEN_VAULT}
    # Enable kv for Vault.
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault secrets enable -version=2 -path=secrets kv
    # Put secret - It's only for test purpose and not to be done in production
    # For the backend
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault kv  put    secrets/exaka/${ENVIRONMENT}/station stationdbrootpassword=rootpassword
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault kv  patch  secrets/exaka/${ENVIRONMENT}/station stationdbpassword=passwordtest
    # For redis
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault kv  patch  secrets/exaka/${ENVIRONMENT}/station stationredispassword=redis60
    # Create policy for stationdevread
    kubectl cp stationdevread.hcl ${VAULT_MONITORING}/vault-0:tmp/stationdevread.hcl
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault policy write stationdevread tmp/stationdevread.hcl
    kubectl exec vault-0 -n ${VAULT_MONITORING} -- vault token create -policy=stationdevread -format json > tokenfile.json
    TOKEN_VAULT=$( cat tokenfile.json | jq -r '.auth.client_token')
        
    kubectl create secret generic vault-secret  --from-literal=token=${TOKEN_VAULT} -n stationdev
    echo "vault-secret-store create with access"
    rm -f tokenfile.json
fi


# Install applications
helm upgrade -i applications ./argocd/applications

# Install applications

# Change namespace to argocd
kubectl config set-context --current --namespace=argocd

# Synchronize applications
argocd --core app sync --prune --retry-limit 2 -l exakaconsulting/strategy=refresh --insecure  

