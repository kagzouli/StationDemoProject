NB_USERS=20
DURATION=60
k6 run --vus=$NB_USERS --duration="${DURATION}s" script.js