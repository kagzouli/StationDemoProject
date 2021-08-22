#!/bin/bash
# Fixe les variables

displayError(){
  BOLD=$(tput bold)
  RED='\033[0;31m'
  NORMAL='\033[0m' 
  echo -e "${RED}${BOLD}$1${NORMAL}"
}

displayMessage(){
  BOLD=$(tput bold)
  BLUE='\033[0;34m'
  NORMAL='\033[0m' 
  echo -e "${BLUE}${BOLD}$1${NORMAL}"
}

AWS_REGION="eu-west-3"  
ECR_OFFICIAL_AWS="602401143452.dkr.ecr.${AWS_REGION}.amazonaws.com"
SHARED_NAMESPACE="transverse"


if [ -z $1 ]
then
   displayError "Il manque le 1er argument. La valeur doit être internal si on veut que redis ou db soit interne, ou external si on veut que ce soit pilotee par un service managee"
   exit 1
fi

TYPE_INSTALL=$1

# Choix du type installation
REDIS_MODE=""
REDIS_USESSL=false
DB_MODE=""
STORAGE_EFS_CLASS="none"
EFS_SYSTEM_ID=""
EFS_ACCESSPOINT_ID=""

case $TYPE_INSTALL in
     "internal")
        displayMessage "On est en mode installation internal - la db et redis sont internes sans EFS pour la db"
        REDIS_MODE="internalredis"
	REDIS_USESSL=false
        DB_MODE="internaldb"
        ;;
     
     "internal_efs")
        displayMessage "On est en mode installation internal - la db et redis sont internes avec EFS pour la db"
        REDIS_MODE="internalredis"
	REDIS_USESSL=false
        DB_MODE="internaldb"
        STORAGE_EFS_CLASS="efs-sc"
        # TODO
        EFS_SYSTEM_ID=$( aws efs describe-file-systems --query FileSystems[?Name==\'stationdb-data\'].FileSystemId --output text )
        echo "EFS_SYSTEM_ID : ${EFS_SYSTEM_ID}"
        EFS_ACCESSPOINT_ID=$( aws efs describe-access-points --query AccessPoints[?Name==\'station-efs-accesspoint\'].AccessPointId --output text )
        echo "EFS_ACCESSPOINT_ID : ${EFS_ACCESSPOINT_ID}"
        ;;
  
  
     "external")
        displayMessage "On est en mode installation external - la db et redis sont des services managees AWS RDS et Redis"
        REDIS_MODE="externalredis"
        REDIS_USESSL=true
	DB_MODE="externaldb"
        ;;

      *)
        displayError "La valeur doit être internal si on veut que redis ou db soit interne, ou external si on veut que ce soit pilotee par un service managee"
        exit 1
        ;;
esac

#Test parametre entree


# Definit les charts par default
helm repo add eks https://aws.github.io/eks-charts
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/

helm repo update

# Recupere les variables
VPC_ID=$( aws ec2 describe-vpcs --filter Name=tag:Name,Values=station_vpc --query 'Vpcs[].VpcId' --output text )
echo "VPC_ID : ${VPC_ID}"

ACCOUNT_NUMBER=$( aws sts get-caller-identity --query 'Account' --output text )
echo "Account number : ${ACCOUNT_NUMBER}"

displayMessage "Connect to the station-eks-cluster"
aws eks --region ${AWS_REGION} update-kubeconfig --name station-eks-cluster


# Lancement du chart transverse
displayMessage  "Installation des services account transverses"
helm upgrade -i transverse ./transverse -n ${SHARED_NAMESPACE}  \
     --set app.accountidentifier="${ACCOUNT_NUMBER}"  


# Install AWS Load balancer controller
displayMessage "Installation de AWS Load balancer controller."
helm upgrade -i station-aws-load-balancer-controller eks/aws-load-balancer-controller \
    --set clusterName=station-eks-cluster \
    --set serviceAccount.create=false \
    --set region=${AWS_REGION} \
    --set vpcId=${VPC_ID} \
    --set serviceAccount.name=station-aws-load-balancer-controller-sa \
    --set image.repository="${ECR_OFFICIAL_AWS}/amazon/aws-load-balancer-controller" \
    --set nameOverride="station-aws-load-balancer-controller" \
    --set fullnameOverride="station-aws-load-balancer-controller" \
    -n ${SHARED_NAMESPACE} \
    --create-namespace


# Install EFS CSI Driver - No need for fargate.
displayMessage "Installation de l'EFS CSI Driver."
helm upgrade -i station-aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --set image.repository="${ECR_OFFICIAL_AWS}/eks/aws-efs-csi-driver" \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=station-efs-csi-controller-sa \
    --namespace ${SHARED_NAMESPACE} \
    --create-namespace


# Install External Secret
displayMessage "Installation de External Secret."
helm upgrade -i  station-external-secrets external-secrets/kubernetes-external-secrets  \
    --set serviceAccount.create=false \
    --set env.AWS_REGION="${AWS_REGION}" \
    --set serviceAccount.name=station-external-secret-sa \
    --set fullnameOverride="station-external-secrets" \
    --set nameOverride="station-external-secrets" \
    --namespace ${SHARED_NAMESPACE} \
    --create-namespace

# Recupere le target group station back
TG_ARN_STATION_BACK=$( aws elbv2 describe-target-groups --name station-back-target-group  --query 'TargetGroups[0].TargetGroupArn' --output text )
echo "Target Group ARN station back : ${TG_ARN_STATION_BACK}"

TG_ARN_STATION_FRONT=$( aws elbv2 describe-target-groups --name station-front-target-group  --query 'TargetGroups[0].TargetGroupArn' --output text )
echo "Target Group ARN station front : ${TG_ARN_STATION_FRONT}"


# Lancement du chart applicatiof station
displayMessage "Installation de l'application station"
helm upgrade -i stationdev ./station  \
     -f awsvalue.yaml \
     --set stationback.ingress.targetGroupARN="${TG_ARN_STATION_BACK}"  \
     --set stationfront.ingress.targetGroupARN="${TG_ARN_STATION_FRONT}" \
     --set stationredis.mode="${REDIS_MODE}" \
     --set stationredis.usessl="${REDIS_USESSL}" \
     --set stationdb.mode="${DB_MODE}" \
     --set stationdb.storage.storageClass="${STORAGE_EFS_CLASS}" \
     --set stationdb.storage.efsid="${EFS_SYSTEM_ID}" \
     --set stationdb.storage.efsaccesspointid="${EFS_ACCESSPOINT_ID}" \
     -n stationdev \
     --create-namespace 

