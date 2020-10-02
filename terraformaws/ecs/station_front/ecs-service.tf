resource "aws_ecs_service" "station_front_ecs_service"{
    name                =  "station_front_ecs_service"
    task_definition     = aws_ecs_task_definition.station_front_ecs_task_definition.arn
    cluster             = aws_ecs_cluster.station_front_ecs_cluster.name
    desired_count       = 1
    launch_type         = "FARGATE"
 #   health_check_grace_period_seconds = 240

    network_configuration{
        subnets             = var.public_subnets
        security_groups     = [aws_security_group.station_front.id]
        assign_public_ip    = true
    }

    

}