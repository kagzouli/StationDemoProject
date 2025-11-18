SHARED_NAMESPACE="transverse"
MONITORING_NAMESPACE="monitoring"
VAULT_MONITORING="vault"
FALCO_NAMESPACE="falco"



STATION_PROJECT_NAME="stationdev"
oc project $STATION_PROJECT_NAME

# Delete all standard resources
oc delete pvc stationdb-data --force
oc delete pv station-pv --all --force
oc delete all --all


# Delete other resources
oc delete configmap --all
oc delete secret --all
oc delete route --all
oc delete pvc stationdb-data --force
oc delete pv station-pv --all --force
oc delete serviceaccount --all
oc delete rolebinding --all
oc delete role --all
oc delete quota --all
oc delete limitrange --all