resource "aws_ecs_service" "station_back_ecs_service"{
    name                              =  "station-back-ecs-service"
    task_definition                   =  aws_ecs_task_definition.station_back_ecs_task_definition.arn
    cluster                           =  aws_ecs_cluster.station_back_ecs_cluster.id
    launch_type                       = "FARGATE"
    
    desired_count                     = var.station_back_count
    health_check_grace_period_seconds = 300
    
 #   health_check_grace_period_seconds = 240
 
    network_configuration{
        subnets             = var.public_subnets_id
        security_groups     = [aws_security_group.sg_station_back_ecs.id]
        assign_public_ip    = true
    }
}