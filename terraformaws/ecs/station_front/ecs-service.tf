resource "aws_ecs_service" "station_front_ecs_service"{
    name =  "station_front_ecs_service"
    cluster = aws_ecs_cluster.station_front_ecs_cluster.name
    launch_type = "EC2"
    health_check_grace_period_seconds = 240

    network_configuration{
        subnets             = var.public_subnets
        security_groups     = [aws_security_group.station_front.id]
    }

    tags = {
        Name = "station_front_ecs_service"
        Application= var.application
    }

}