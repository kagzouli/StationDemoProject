#!/bin/bash
# Fixe les variables

displayError(){
  RED='\033[0;31m'
  NORMAL='\033[0m' 
  echo -e "${RED}$1${NORMAL}"
}


if [ -z $1 ]
then
   displayError "Il manque le 1er argument. La valeur doit être le token de vault pour se connecter"
   exit 1
fi

# Varible
TOKEN=$1
ENVIRONMENT="dev"
export VAULT_ADDR='http://stationvault.exakaconsulting.org:8200'


# Login to vault
vault login $TOKEN

# Enable kv for Vault.
vault secrets enable -version=2 -path=secrets kv

# Put secret - It's only for test purpose and not to be done in production
# For the backend
vault kv  put    secrets/exaka/${ENVIRONMENT}/station stationdbrootpassword=rootpassword
vault kv  patch  secrets/exaka/${ENVIRONMENT}/station stationdbpassword=passwordtest
# For redis
vault kv  patch  secrets/exaka/${ENVIRONMENT}/station stationredispassword=redis60

# Create policy for stationdevread
vault policy write stationdevread stationdevread.hcl
vault token create -policy=stationdevread


