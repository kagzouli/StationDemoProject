resource "aws_ecs_cluster" "station_db_ecs_cluster"{
    name = "station_db_ecs_cluster"
    tags = {
        Name = "station_db_ecs_cluster"
        Application= var.application
    }
}