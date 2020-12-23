resource "aws_ecs_service" "station_front_ecs_service"{
    name                              =  "station-front-ecs-service"
    task_definition                   = aws_ecs_task_definition.station_front_ecs_task_definition.arn
    cluster                           = aws_ecs_cluster.station_front_ecs_cluster.id
    launch_type                       = "EC2"
    force_new_deployment              = true

    desired_count                     = var.station_front_count
    health_check_grace_period_seconds = 300
 
    network_configuration{
        subnets             = var.private_subnets_id
        security_groups     = [aws_security_group.sg_station_front_ecs.id]
    }    

    load_balancer {
        target_group_arn   = aws_alb_target_group.station_front_target_group.id
        container_name     = "station-front"
        container_port     = var.station_front_container_port
    }

    depends_on = [aws_alb_listener.station_front_alb_listener]

    tags = {
       name = "station-front-ecs-service"
    }

    

}
