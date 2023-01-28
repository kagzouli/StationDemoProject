#!/bin/bash
# Fixe les variables

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

if [ -z $1 ]
then
   displayError "Il manque le 1er argument. La valeur doit être internal si on veut que le mot de passe soit stocké par variable, soit vault si on veut que le mot de passe soit recupéré dans la vault."
   exit 1
fi

TYPE_INSTALL=$1

case $TYPE_INSTALL in
     "internal")
        displayMessage "On est en mode installation internal - le mot de passe est stocké en interne."
        SECRETS_MODE="internal"
        ;;
      
     "vault")
        displayMessage "On est en mode installation internal - le mot de passe est stocké dans la vault."
        SECRETS_MODE="vault"
        ;;

      *)
        displayError "La valeur doit être internal si on veut que le mot de passe soit stocké en local, soit vault si on veut qu'il soit stocké dans la vault"
        exit 1
        ;;
esac


SHARED_NAMESPACE="transverse"

kubectl create namespace ${SHARED_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server --version 3.8.2 --set  args[0]="--kubelet-insecure-tls=true" -n ${SHARED_NAMESPACE}
helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n ${SHARED_NAMESPACE}
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n ${SHARED_NAMESPACE} --create-namespace
helm upgrade --install external-secrets external-secrets/external-secrets --version 0.7.2

# Check that Argo Rollout are is Running or failed state 
NOTPENDING_ARGO_ROLLOUT=$( kubectl get pods -n ${SHARED_NAMESPACE} -o json  | jq -r '.items[] |  select( (.metadata.name |  contains("argo-rollout")) and (.status.phase=="Running" or .status.phase=="Failed"))' | jq -jr '.metadata | .name, ", " ')
while [[ -z "${NOTPENDING_ARGO_ROLLOUT}" ]]
do
  echo "Les pods ${NOTPENDING_ARGO_ROLLOUT} de ArgoRollout sont encore en cours"
  sleep 5s
  NOTPENDING_ARGO_ROLLOUT=$( kubectl get pods -n ${SHARED_NAMESPACE} -o json  | jq -r '.items[] |  select( (.metadata.name |  contains("argo-rollout")) and (.status.phase=="Running" or .status.phase=="Failed"))' | jq -jr '.metadata | .name, ", " ')
done

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

helm upgrade --install stationdev ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n stationdev --create-namespace

kubectl apply -f ipaddress_pools.yaml
