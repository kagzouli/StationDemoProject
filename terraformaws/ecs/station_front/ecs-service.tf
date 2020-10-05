resource "aws_ecs_service" "station_front_ecs_service"{
    name                =  "station_front_ecs_service"
    task_definition     = aws_ecs_task_definition.station_front_ecs_task_definition.arn
    cluster             = aws_ecs_cluster.station_front_ecs_cluster.id
    launch_type         = "EC2"
    health_check_grace_period_seconds = 300
 
    network_configuration{
        subnets             = var.private_subnets_id
        security_groups     = [aws_security_group.station_front.id]
        assign_public_ip    = false
    }

    load_balancer {
        elb_name =  aws_elb.station_front_alb.name
        container_name = "station_front"
        container_port = var.station_front_container_port
    }

    

}
