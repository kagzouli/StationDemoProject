#!/bin/bash
# Fixe les variables

SHARED_NAMESPACE="transverse"
STATION_PROJECT_NAME="stationdev"
ENVIRONMENT="dev"

VAULT_MONITORING="vault"
# Only for testing , not in production
ROOT_TOKEN_VAULT="token123"
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
#kubectl create namespace ${SHARED_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
#kubectl create namespace stationdev --dry-run=client -o yaml | kubectl apply -f -


# Create project stationdev
# Check if the project exists
if oc get project "$STATION_PROJECT_NAME" &>/dev/null; then
  echo "Project '$STATION_PROJECT_NAME' already exists."
else
  echo "Project '$STATION_PROJECT_NAME' does not exist. Creating..."
  oc new-project "$STATION_PROJECT_NAME"
  if [ $? -eq 0 ]; then
    echo "Project '$STATION_PROJECT_NAME' created successfully."
  else
    echo "Failed to create project '$STATION_PROJECT_NAME'."


# Install stationdev
helm upgrade --install $STATION_PROJECT_NAME ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n STATION_PROJECT_NAME --create-namespace