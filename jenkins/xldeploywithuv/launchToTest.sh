# Params
NB_USERS=40
WAIT_TIME=6
NAMESPACE_NAME="stationdev"
CONTAINER_NAME="stationback"
LOAD_TEST="/tmp/karim/loadtest/data.txt"
TOKEN="XXXXXXXX

uv run python -m loadtest http://stationback.exakaconsulting.org:8080/StationDemoSecureWeb/station/stations --nbr-users=${NB_USERS} --wait-time=${WAIT_TIME} --namespace-name=${NAMESPACE_NAME} --container-name=${CONTAINER_NAME} --token=${TOKEN} --load-file=${LOAD_TEST}