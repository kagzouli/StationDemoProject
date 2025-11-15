#!/bin/bash
# Fixe les variables

SHARED_PROJECT_NAME="transverse"
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

# Repository helm
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add external-secrets https://charts.external-secrets.io
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
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

# Check if the station exists
if oc get project "$STATION_PROJECT_NAME" &>/dev/null; then
  echo "Project '$STATION_PROJECT_NAME' already exists."
else
  echo "Project '$STATION_PROJECT_NAME' does not exist. Creating..."
  oc new-project "$STATION_PROJECT_NAME"
  if [ $? -eq 0 ]; then
    echo "Project '$STATION_PROJECT_NAME' created successfully."
  else
    echo "Failed to create project '$STATION_PROJECT_NAME'."
    fi
fi

# Install external secrets
# Launch and check that external secrets are is Running or failed state
helm
helm upgrade --install external-secrets external-secrets/external-secrets --version 0.7.2 -n ${SHARED_PROJECT_NAME} --create-namespace
checkIfPodsReady "external-secrets" "app.kubernetes.io/name=external-secrets" "${SHARED_PROJECT_NAME}"



# Install stationdev
helm upgrade --install $STATION_PROJECT_NAME ./station \
   --set secrets.mode="${SECRETS_MODE}" \
   -n $STATION_PROJECT_NAME --create-namespace
