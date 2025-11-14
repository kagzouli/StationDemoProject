#!/bin/bash
# Fixe les variables

SHARED_NAMESPACE="transverse"
AWS_REGION="eu-west-3"
MONITORING_NAMESPACE="monitoring"
VAULT_MONITORING="vault"
# Only for testing , not in production
ROOT_TOKEN_VAULT="token123"
ENVIRONMENT="dev"
FALCO_NAMESPACE="falco"

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

if [ -z $1 ]
then
   displayError "Il manque le 1er argument. La valeur doit être internal si on veut que le mot de passe soit stocké par variable, soit vault si on veut que le mot de passe soit recupéré dans la vault."
   exit 1
fi

TYPE_INSTALL=$1

# Repository helm
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add external-secrets https://charts.external-secrets.io
helm repo add kedacore https://kedacore.github.io/charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
helm repo update

# Creation namespace
kubectl create namespace ${SHARED_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stationdev --dry-run=client -o yaml | kubectl apply -f -


# Launch and check that Ingress nginx are is Running or failed state
NS_INGRESS_NUMBER=$( kubectl get ns |grep ingress-nginx |wc -l )
if [[ "${NS_INGRESS_NUMBER}" -eq 0 ]]; then
  helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n ${SHARED_NAMESPACE} --create-namespace
  checkIfPodsReady "ingress-nginx" "app.kubernetes.io/instance=ingress-nginx" "${SHARED_NAMESPACE}"
else
  displayMessage "Le namespace ingress-nginx existe."
fi


case $TYPE_INSTALL in
     "internal")
        displayMessage "On est en mode installation internal - le mot de passe est stocké en interne."
        SECRETS_MODE="internal"
        ;;
      
     "vault")
        displayMessage "On est en mode installation vault - le mot de passe est stocké dans la vault."
        SECRETS_MODE="vault"

  
        # Install Vault
        helm upgrade --install  vault hashicorp/vault --version 0.25.0 --set csi.agent.enabled="false" --set server.dev.enabled="true"  --set server.dev.devRootToken="${ROOT_TOKEN_VAULT}" --set ui.enabled="true" --set ui.serviceType="NodePort" -n ${VAULT_MONITORING} --create-namespace
        checkIfPodsReady "Vault" "app.kubernetes.io/name=vault" "${VAULT_MONITORING}"
        kubectl apply -f vault-ing.yaml

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
          displayMessage "vault-secret-store create with access"
          rm -f tokenfile.json

        else
          displayMessage "vault-secret-store already exists"
        fi
        ;;

      *)
        displayError "La valeur doit être internal si on veut que le mot de passe soit stocké en local, soit vault si on veut qu'il soit stocké dans la vault"
        exit 1
        ;;
esac

# Install falco - Audit cluster
helm upgrade --install falco falcosecurity/falco --version 3.7.1 --set falcosidekick.enabled=true --set falcosidekick.webui.enabled=true --set driver.kind=modern-bpf -n ${FALCO_NAMESPACE}  --create-namespace 
kubectl apply -f falco-ing.yaml

# Launch and Check that metrics server are is Running or failed state 
helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n ${SHARED_NAMESPACE}
checkIfPodsReady "metrics-server" "app.kubernetes.io/name=metrics-server" "${SHARED_NAMESPACE}"

# Launch and check that Argo Rollout are is Running or failed state 
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n ${SHARED_NAMESPACE}
checkIfPodsReady "ArgoRollout" "app.kubernetes.io/name=argo-rollouts" "${SHARED_NAMESPACE}"



# Launch and check that external secrets are is Running or failed state
helm upgrade --install external-secrets external-secrets/external-secrets --version 0.7.2 -n ${SHARED_NAMESPACE} --create-namespace
checkIfPodsReady "external-secrets" "app.kubernetes.io/name=external-secrets" "${SHARED_NAMESPACE}"


# Launch and check that metallb are is Running or failed state
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
checkIfPodsReady "metallb" "app=metallb" "metallb-system"

#helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler --set awsRegion=${AWS_REGION} --set "autoscalingGroups[0].name=kubworker-ec2" --set "autoscalingGroups[0].minSize=2" --set "autoscalingGroups[0].maxSize=4" --set cloudProvider=aws -n ${SHARED_NAMESPACE} --create-namespace
# Launch keda
helm upgrade --install keda kedacore/keda -n ${SHARED_NAMESPACE} --create-namespace  
checkIfPodsReady "keda" "app.kubernetes.io/name=keda-operator" "${SHARED_NAMESPACE}"

# Install kube-state-metrics
helm upgrade --install kube-state-metrics prometheus-community/kube-state-metrics --version 5.14.0 -n ${MONITORING_NAMESPACE} --create-namespace
checkIfPodsReady "kube-state-metrics" "app.kubernetes.io/name=kube-state-metrics" "${MONITORING_NAMESPACE}"

# Install prometheus operator CRD
helm upgrade --install prometheus-operator-crds prometheus-community/prometheus-operator-crds --version 5.1.0 -n ${MONITORING_NAMESPACE} --create-namespace

# Install cadvisor
helm upgrade --install cadvisor ckotzbauer/cadvisor --version 2.2.4 -n ${MONITORING_NAMESPACE} --create-namespace
checkIfPodsReady "cadvisor" "app=cadvisor" "${MONITORING_NAMESPACE}"
kubectl apply -f cadvisor_sm.yaml


# Install prometheus server
helm upgrade --install prometheus  prometheus-community/prometheus --version 25.0.0 --set server.persistentVolume.enabled="false" --set server.service.type="NodePort" --set server.service.nodePort="30001" -f values_prometheus.yaml  -n ${MONITORING_NAMESPACE} --create-namespace
kubectl apply -f prometheus-ing.yaml
 

# Install stationdev
helm upgrade --install stationdev ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n stationdev --create-namespace

kubectl apply -f ipaddress_pools.yaml

# Change current context
kubectl config set-context --current --namespace=stationdev
