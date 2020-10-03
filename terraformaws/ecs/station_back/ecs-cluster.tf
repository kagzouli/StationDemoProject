resource "aws_ecs_cluster" "station_back_ecs_cluster"{
    name = "station_back_ecs_cluster"
    tags = {
        Name = "station_back_ecs_cluster"
        Application= var.application
    }
}