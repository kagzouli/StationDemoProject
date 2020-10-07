resource "aws_ecs_cluster" "station_back_ecs_cluster"{
    name = "station-back-ecs-cluster"
    tags = {
        Name = "station-back-ecs-cluster"
        Application= var.application
    }
}