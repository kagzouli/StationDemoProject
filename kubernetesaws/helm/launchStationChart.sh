#!/bin/bash
# Fixe les variables

SHARED_NAMESPACE="transverse"
AWS_REGION="eu-west-3"
MONITORING_NAMESPACE="monitoring"

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

# Creation namespace
kubectl create namespace ${SHARED_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace stationdev --dry-run=client -o yaml | kubectl apply -f -

case $TYPE_INSTALL in
     "internal")
        displayMessage "On est en mode installation internal - le mot de passe est stocké en interne."
        SECRETS_MODE="internal"
        ;;
      
     "vault")
        displayMessage "On est en mode installation vault - le mot de passe est stocké dans la vault."
        SECRETS_MODE="vault"

        if [ -z $2 ]
        then
          displayError "Il manque le 2eme argument. La valeur doit être le token de la vault."
          exit 1
        fi

        TOKEN=$2

        # Fait pour creer le secret stockant le token 
        RESULT_VAULT_SECRETS=$( kubectl get secret -n stationdev | grep vault-secret | wc -l)
          echo "Result Vault Secrets : ${RESULT_VAULT_SECRETS}"
          if [[ "${RESULT_VAULT_SECRETS}" -eq 0 ]]; then
            kubectl create secret generic vault-secret  --from-literal=token=${TOKEN} -n stationdev
            displayMessage "vault-secret-store create with access"
          else
            displayMessage "vault-secret-store already exists"
          fi

        ;;

      *)
        displayError "La valeur doit être internal si on veut que le mot de passe soit stocké en local, soit vault si on veut qu'il soit stocké dans la vault"
        exit 1
        ;;
esac





helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add external-secrets https://charts.external-secrets.io
helm repo add kedacore https://kedacore.github.io/charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Launch and Check that metrics server are is Running or failed state 
helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n ${SHARED_NAMESPACE}
checkIfPodsReady "metrics-server" "app.kubernetes.io/name=metrics-server" "${SHARED_NAMESPACE}"

# Launch and check that Argo Rollout are is Running or failed state 
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n ${SHARED_NAMESPACE}
checkIfPodsReady "ArgoRollout" "app.kubernetes.io/name=argo-rollouts" "${SHARED_NAMESPACE}"


# Launch and check that Ingress nginx are is Running or failed state
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n ${SHARED_NAMESPACE} --create-namespace
checkIfPodsReady "ingress-nginx" "app.kubernetes.io/instance=ingress-nginx" "${SHARED_NAMESPACE}"


# Launch and check that external secrets are is Running or failed state
helm upgrade --install external-secrets external-secrets/external-secrets --version 0.7.2 -n ${SHARED_NAMESPACE} --create-namespace
checkIfPodsReady "external-secrets" "app.kubernetes.io/name=external-secrets" "${SHARED_NAMESPACE}"


# Launch and check that metallb are is Running or failed state
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
checkIfPodsReady "metallb" "app=metallb" "metallb-system"

#helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler --set awsRegion=${AWS_REGION} --set "autoscalingGroups[0].name=kubworker-ec2" --set "autoscalingGroups[0].minSize=2" --set "autoscalingGroups[0].maxSize=4" --set cloudProvider=aws -n ${SHARED_NAMESPACE} --create-namespace
# Launch keda
helm upgrade --install keda kedacore/keda -n ${SHARED_NAMESPACE} --create-namespace  
checkIfPodsReady "keda" "app.kubernetes.io/name=keda-operator" "${SHARED_NAMESPACE}" --create-namespace

# Install prometheus operator
helm upgrade --install prometheus  prometheus-community/prometheus --version 25.0.0 -n ${MONITORING_NAMESPACE} --create-namespace

# Install prometheus adapter
helm upgrade --install prom-adapter prometheus-community/prometheus-adapter --version 4.5.0 --set prometheus.url="http://prom-prometheus-operator-prometheus.${MONITORING_NAMESPACE}.svc",prometheus.port="9090"  --set rbac.create="true" -n ${MONITORING_NAMESPACE} --create-namespace

# Install stationdev
helm upgrade --install stationdev ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n stationdev --create-namespace

kubectl apply -f ipaddress_pools.yaml

# Change current context
kubectl config set-context --current --namespace=stationdev
