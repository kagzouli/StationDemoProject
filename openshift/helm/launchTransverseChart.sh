#!/bin/bash
# Fixe les variables

SHARED_PROJECT_NAME="transverse"

ENVIRONMENT="dev"
ADMIN_CONJUR_PASSWORD="StationDemo*01"

VAULT_MONITORING="vault"
# Only for testing , not in production
ROOT_TOKEN_VAULT="token123"
FALCO_NAMESPACE="falco"

export DATA_KEY=$(docker run --rm cyberark/conjur data-key generate)

echo "Data key is ${DATA_KEY}"

displayError(){
  RED='\033[0;31m'
  NORMAL='\033[0m' 
  echo -e "${RED}$1${NORMAL}"
}

displayMessage(){
  BLUE='\033[0;34m'
  NORMAL='\033[0m' 
  echo -e "${BLUE}$1${NORMAL}"
}

# Parametre 1 : Nom du pod a tester
# Parametre 1 : Label to check --> Example app.kubernetes.io/name=argo-rollouts
# Parametre 3 : namespace
checkIfPodsReady(){
  echo "Test : $1, $2, $3"
  while [[ $(kubectl get pods -l $2  -n $3 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != *"True"* ]]; do
    sleep 5
    displayMessage "Les pods $1 sont encore en cours de démarrage"
  done
}

# Repository helm
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add external-secrets https://charts.external-secrets.io
helm repo add cyberark https://cyberark.github.io/helm-charts  
helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update



# Check if the project transverse exists
if oc get project "$SHARED_PROJECT_NAME" &>/dev/null; then
  echo "Project '$SHARED_PROJECT_NAME' already exists."
else
  echo "Project '$SHARED_PROJECT_NAME' does not exist. Creating..."
  oc new-project "$SHARED_PROJECT_NAME"
  if [ $? -eq 0 ]; then
    echo "Project '$SHARED_PROJECT_NAME' created successfully."
  else
    echo "Failed to create project '$SHARED_PROJECT_NAME'."
    fi
fi


# Install external secrets
# Launch and check that external secrets are is Running or failed state
oc project ${SHARED_PROJECT_NAME}

# Add policy for openshift
# En dev uniquement 
oc adm policy add-scc-to-user anyuid -z metrics-server  -n $SHARED_PROJECT_NAME


helm upgrade --install external-secrets external-secrets/external-secrets --wait  --version 0.7.2 -n ${SHARED_PROJECT_NAME}
checkIfPodsReady "external-secrets" "app.kubernetes.io/name=external-secrets" "${SHARED_PROJECT_NAME}"

helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n ${SHARED_PROJECT_NAME} --wait 
checkIfPodsReady "metrics-server" "app.kubernetes.io/name=metrics-server" "${SHARED_PROJECT_NAME}"

# Install cyberark
# Add sa conjur-sa
oc create sa conjur-sa -n ${SHARED_PROJECT_NAME}
oc adm policy add-scc-to-user anyuid system:serviceaccount:${SHARED_PROJECT_NAME}:conjur-sa
oc adm policy add-scc-to-user anyuid -z system:serviceaccount:${SHARED_PROJECT_NAME}:default

# Install database postgresql for conjur
helm upgrade --install postgresql bitnami/postgresql --version 18.1.9 \
  --namespace ${SHARED_PROJECT_NAME} \
  --set global.postgresql.auth.username=conjur \
  --set global.postgresql.auth.postgresPassword=conjurpass \
  --set auth.username=conjur \
  --set auth.password=conjurpass \
  --set auth.database=conjur \
  --set global.postgresql.auth.database=conjur \
  --set primary.persistence.enabled=false --wait


helm upgrade --install conjur  cyberark/conjur-oss --set serviceAccount.name=conjur-sa --set serviceAccount.create=false --set database.external=false --version 2.0.7   -n ${SHARED_PROJECT_NAME} \
      --set adminPassword.value="${ADMIN_CONJUR_PASSWORD}" --set adminPassword.dataKey="${DATA_KEY}" --set dataKey="${DATA_KEY}" \
      --set database.type=postgres \
      --set database.external=true \
      --set database.host=postgresql.transverse.svc.cluster.local \
      --set database.url=postgresql://conjur:conjurpass@postgresql.transverse.svc.cluster.local:5432/conjur \
      --set database.port=5432 \
      --set database.name=conjur \
      --set database.user=conjur \
      --set database.password=conjurpass \
      --set expose.type=route \
      --set expose.tls=false \
      --set account.create=true



#oc delete route conjur 
#oc create route passthrough conjur --service=conjur-conjur-oss --hostname="conjur.exakaconsulting.org" 
     


# Install transverse
helm upgrade --install $SHARED_PROJECT_NAME --wait  ./transverse -n ${SHARED_PROJECT_NAME} 
