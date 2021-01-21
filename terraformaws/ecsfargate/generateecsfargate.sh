echo "Apply terraform change"
terraform apply -auto-approve --lock=false --var-file=../vars/dev.tvars

# Relaunch the back-end to take into account the new task definition
echo "Relaunch the backend to take into account the new task definition"
aws ecs list-tasks --cluster station-back-ecs-cluster --service-name station-back-ecs-service | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster station-back-ecs-cluster --task \""$0"\""}' | sh

# Relaunch the front to take into account the new task definition
echo "Relaunch the frontend to take into account the new task definition"
aws ecs list-tasks --cluster station-front-ecs-cluster --service-name station-front-ecs-service | jq -r ".taskArns[]" | awk '{print "aws ecs stop-task --cluster station-front-ecs-cluster --task \""$0"\""}' | sh

