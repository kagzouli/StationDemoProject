STATION_PROJECT_NAME="stationdev"


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

oc project $STATION_PROJECT_NAME

# Add policy for openshift
# En dev uniquement 
oc adm policy add-scc-to-user anyuid -z station -n $STATION_PROJECT_NAME
oc adm policy add-scc-to-user 20050-securityconstraints system:serviceaccount:$STATION_PROJECT_NAME:station


# Install stationdev
helm upgrade --install $STATION_PROJECT_NAME ./station -n $STATION_PROJECT_NAME --wait  \
   --set secrets.mode="${SECRETS_MODE}" 
