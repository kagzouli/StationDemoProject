pip install  .

# Params
NB_USERS=15
WAIT_TIME=12
NAMESPACE_NAME="stationdev"
CONTAINER_NAME="stationback"
LOAD_TEST="D:\Karim\dev\workspace\StationDemoProject\loadTest\python3\loadtest\utils\k6\data.txt"

# Exec
loadtest http://stationback.exakaconsulting.org/StationDemoSecureWeb/station/stations --nbr-users=${NB_USERS} --wait-time=${WAIT_TIME} --namespace-name=${NAMESPACE_NAME} --container-name=${CONTAINER_NAME} --load-file=${LOAD_TEST}