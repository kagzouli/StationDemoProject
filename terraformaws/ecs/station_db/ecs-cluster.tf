resource "aws_ecs_cluster" "station_db_ecs_cluster"{
    name = "station-db-ecs-cluster"
    tags = {
        Name = "station-db-ecs-cluster"
        Application= var.application
    }
}
