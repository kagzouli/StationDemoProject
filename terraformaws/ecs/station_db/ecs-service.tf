resource "aws_ecs_service" "station_db_ecs_service"{
    name                =  "station-db-ecs-service"
    task_definition     = aws_ecs_task_definition.station_db_ecs_task_definition.arn 
    cluster             = aws_ecs_cluster.station_db_ecs_cluster.id
    desired_count       = 1
    launch_type         = "FARGATE"
 
    network_configuration{
        subnets             = var.subnets_id
        security_groups     = [aws_security_group.sg_station_db_ecs.id]
        assign_public_ip    = true
    }

    load_balancer {
        target_group_arn   = aws_alb_target_group.station_db_target_group.id
        container_name     = "station-db"
        container_port     = 3306
    }

    depends_on = [aws_alb_listener.station_db_alb_listener]


    

}
