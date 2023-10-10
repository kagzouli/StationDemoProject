#!/bin/bash
# Fixe les variables

displayError(){
  RED='\033[0;31m'
  NORMAL='\033[0m' 
  echo -e "${RED}$1${NORMAL}"
}

NB_USERS=100
DURATION=60
WAIT_TIME=1


if [ -z $1 ]
then
   displayError "Il manque le 1er argument. La valeur doit être le token de l'utilisateur pour se connecter"
   exit 1
fi

k6 run -e TOKEN=$1 --vus=$NB_USERS --duration="${DURATION}s" -e LOAD_FILE_TEST=data.txt -e WAIT_TIME=$WAIT_TIME script.js
