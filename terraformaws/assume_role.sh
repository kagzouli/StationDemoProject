#!/bin/bash
# Test if parameter 1 is set --> profile name
if [[ -z $1 ]]; then
    echo Missing profile name
    echo
    echo Usage: . assume_role profile-name role_name [--show]
    echo
# Test if parameter 2 is set --> Role
elif [[ -z $2 ]]; then
    echo Missing role name
    echo
    echo Usage: . assume_role profile-name role_name [--show]
    echo
else
     ACCOUNT_NUMBER=$( aws sts get-caller-identity --query 'Account' --output text)
     echo ACCOUNT_NUMBER : ${ACCOUNT_NUMBER}
     OUT=$( aws sts assume-role --duration-seconds 3600   --role-arn arn:aws:iam::${ACCOUNT_NUMBER}:role/$2 --role-session-name $1); \
     
     # Recuperation de l'access key et secret key
     export AWS_ACCESS_KEY_ID=$( echo $OUT  | jq -r '.Credentials.AccessKeyId') \
     export AWS_SECRET_ACCESS_KEY=$( echo $OUT  | jq -r '.Credentials.SecretAccessKey')
     export AWS_SECRET_EXPIRATION=$( echo $OUT | jq -r '.Credentials.Expiration')     
     export AWS_SESSION_TOKEN=$( echo $OUT | jq -r '.Credentials.SessionToken')

     echo "AWS_ACCESS_KEY_ID : ${AWS_ACCESS_KEY_ID}"
     echo "AWS_SECRET_ACCESS_KEY : ${AWS_SECRET_ACCESS_KEY}"
     echo "AWS_SECRET_EXPIRATION : ${AWS_SECRET_EXPIRATION}"
     echo "AWS_SESSION_TOKEN : ${AWS_SESSION_TOKEN}"

     
     aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID  
     aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY  
     aws configure set aws_session_token $AWS_SESSION_TOKEN 

fi


