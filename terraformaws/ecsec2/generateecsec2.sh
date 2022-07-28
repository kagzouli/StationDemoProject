echo "Apply terraform change"
CPT_NAME="dev"
rm -rf .terraform
terraform init --backend-config="backends/${CPT_NAME}_backend.tfvars"
terraform apply -auto-approve --lock=false --var-file=../vars/${CPT_NAME}.tvars 

# Relaunch the back-end to take into account the new task definition
echo "Relaunch the backend to take into account the new task definition"
aws ecs list-tasks --cluster station-back-ecs-cluster --service-name station-back-ecs-service | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster station-back-ecs-cluster --task \""$0"\""}' | sh

# Relaunch the front to take into account the new task definition
echo "Relaunch the frontend to take into account the new task definition"
aws ecs list-tasks --cluster station-front-ecs-cluster --service-name station-front-ecs-service | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster station-front-ecs-cluster --task \""$0"\""}' | sh
