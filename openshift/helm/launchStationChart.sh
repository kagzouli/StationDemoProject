#!/bin/bash
# Fixe les variables

SHARED_PROJECT_NAME="transverse"
STATION_PROJECT_NAME="stationdev"
ENVIRONMENT="dev"
ADMIN_CONJUR_PASSWORD="StationDemo*01"
DATA_KEY="admin-password"

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
helm repo add cyberark https://cyberark.github.io/helm-charts  
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
helm upgrade --install conjur cyberark/conjur-oss --wait --set serviceAccount.name=conjur-sa --set serviceAccount.create=false --version 2.0.7 --skip-crds  -n ${SHARED_PROJECT_NAME} \
      --set adminPassword.value="${ADMIN_CONJUR_PASSWORD}" --set adminPassword.dataKey="${DATA_KEY}" --set dataKey="${DATA_KEY}"


oc delete route conjur 
oc create route passthrough conjur --service=conjur-conjur-oss --hostname="conjur.exakaconsulting.org" 
     


# Install transverse
helm upgrade --install $SHARED_PROJECT_NAME --wait  ./transverse -n ${SHARED_PROJECT_NAME} 


oc project $STATION_PROJECT_NAME

# Add policy for openshift
# En dev uniquement 
oc adm policy add-scc-to-user anyuid -z station -n $STATION_PROJECT_NAME
oc adm policy add-scc-to-user 20050-securityconstraints system:serviceaccount:$STATION_PROJECT_NAME:station


# Install stationdev
helm upgrade --install $STATION_PROJECT_NAME ./station -n $STATION_PROJECT_NAME --wait  \
   --set secrets.mode="${SECRETS_MODE}" 
