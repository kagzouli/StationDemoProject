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
# Check that metrics server are is Running or failed state 
while [[ $(kubectl get pods -l app.kubernetes.io/name=metrics-server -n ${SHARED_NAMESPACE} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   sleep 5
   displayMessage "Les pods metrics-server sont encore en cours de démarrage"
done

helm upgrade --install argo-rollout argo/argo-rollouts --version 2.21.3 --set installCRDs=true -n ${SHARED_NAMESPACE}
# Check that Argo Rollout are is Running or failed state 
while [[ $(kubectl get pods -l app.kubernetes.io/name=argo-rollouts -n ${SHARED_NAMESPACE} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   sleep 5
   displayMessage "Les pods ArgoRollout sont encore en cours de démarrage"
done


# Check that Ingress nginx are is Running or failed state
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx    --version 4.4.2 -n ${SHARED_NAMESPACE} --create-namespace
while [[ $(kubectl get pods -l app.kubernetes.io/instance=ingress-nginx -n ${SHARED_NAMESPACE} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   sleep 5
   displayMessage "Les pods ingress-nginx sont encore en cours de démarrage"
done

# Check that external secrets are is Running or failed state
helm upgrade --install external-secrets external-secrets/external-secrets --version 0.7.2 -n ${SHARED_NAMESPACE} --create-namespace
while [[ $(kubectl get pods -l app.kubernetes.io/name=external-secrets -n ${SHARED_NAMESPACE} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   sleep 5
   displayMessage "Les pods external-secrets sont encore en cours de démarrage"
done

# Check that metallb are is Running or failed state
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
while [[ $(kubectl get pods -l app=metallb -n metallb-system -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   sleep 5
   displayMessage "Les pods external-secrets sont encore en cours de démarrage"
done

helm upgrade --install stationdev ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n stationdev --create-namespace

kubectl apply -f ipaddress_pools.yaml
