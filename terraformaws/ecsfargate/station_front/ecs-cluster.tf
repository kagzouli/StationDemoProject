resource "aws_ecs_cluster" "station_front_ecs_cluster"{
    name = "station-front-ecs-cluster"
    tags = {
        Name = "station-front-ecs-cluster"
        Application= var.application
    }
}