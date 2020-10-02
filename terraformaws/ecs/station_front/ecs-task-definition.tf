resource "aws_ecs_task_definition" "station_front_ecs_task_definition"{

    family              = "station_front_ecs_task_definition"
    network_mode        = "awsvpc"
    memory              = var.station_front_container_memory
    cpu                 = var.station_front_container_cpu

}