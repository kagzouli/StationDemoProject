# Fixe les variables
AWS_REGION="eu-west-3"  
ECR_OFFICIAL_AWS="602401143452.dkr.ecr.${AWS_REGION}.amazonaws.com"
SHARED_NAMESPACE="transverse"

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

echo "Connect to the station-eks-cluster"
aws eks --region ${AWS_REGION} update-kubeconfig --name station-eks-cluster


# Lancement du chart transverse
echo "Installation des services account transverses"
helm install transverse ./transverse -n ${SHARED_NAMESPACE}  \
     --set app.accountidentifier="${TG_ARN_STATION_BACK}"  


# Install AWS Load balancer controller
echo "Installation de AWS Load balancer controller."
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
echo "Installation de l'EFS CSI Driver."
helm upgrade -i station-aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --set image.repository="${ECR_OFFICIAL_AWS}/eks/aws-efs-csi-driver" \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=station-efs-csi-controller-sa \
    --namespace ${SHARED_NAMESPACE} \
    --create-namespace


# Install External Secret
echo "Installation de External Secret."
helm upgrade -i  station-external-secrets external-secrets/kubernetes-external-secrets  \
    --set serviceAccount.create=false \
    --set env.AWS_REGION="${AWS_REGION}" \
    --set serviceAccount.name=station-external-secret-sa \
    --set fullnameOverride="station-external-secrets" \
    --set nameOverride="station-external-secrets" \
    --namespace ${SHARED_NAMESPACE} \
    --create-namespace

# Recupere le target group station back
# Get the target group of web console internal gateway
TG_ARN_STATION_BACK=$( aws elbv2 describe-target-groups --name station-back-target-group  --query 'TargetGroups[0].TargetGroupArn' --output text )
echo "Target Group ARN station back : ${TG_ARN_STATION_BACK}"

TG_ARN_STATION_FRONT=$( aws elbv2 describe-target-groups --name station-front-target-group  --query 'TargetGroups[0].TargetGroupArn' --output text )
echo "Target Group ARN station front : ${TG_ARN_STATION_FRONT}"


kubectl apply -f efsstorage/efs-csidriver.yaml
kubectl apply -f efsstorage/efs-storageclass.yaml

# Lancement du chart applicatiof station
helm install stationdev ./station  \
     -f awsvalue.yaml \
     --set stationback.ingress.targetGroupARN="${TG_ARN_STATION_BACK}"  \
     --set stationfront.ingress.targetGroupARN="${TG_ARN_STATION_FRONT}" \
     -n stationdev \
     --create-namespace 

