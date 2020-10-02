resource "aws_ecs_cluster" "station_front_ecs_cluster"{
     name = "station_front_ecs_cluster"
     tags = {
         Name = "station_front_ecs_cluster"
         Application= var.application
     }
}