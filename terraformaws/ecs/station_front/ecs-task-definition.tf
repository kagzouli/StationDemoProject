resource "aws_ecs_task_definition" "station_front_ecs_task_definition"{
    family                      = "station_front_ecs_task_definition"
    network_mode                = "awsvpc"
    requires_compatibilities    = ["FARGATE"]
    memory                      = var.station_front_container_memory
    cpu                         = var.station_front_container_cpu
    container_definitions       = data.template_file.station_front.rendered
    task_role_arn               = var.task_role_arn
    execution_role_arn          = var.execution_role_arn

    /*volume {
        name = "efs-station-front-data"
        efs_volume_configuration {
          file_system_id = aws_efs_file_system.station_front_efs.id
          root_directory = "/station-front/config"
        }
    }*/
 
    tags = {
        Name = "station-front-ecs-service"
        Application= var.application
    }

}

data "template_file"  "station_front"{
    template =  file("${path.module}/tasks-definition/station_front.json")

    vars = {
        station_front_image                 = var.station_front_image
        station_front_host_port             = var.station_front_host_port
        station_front_container_port        = var.station_front_container_port
        region                              = var.region
        station_front_clientidtrafstat      = var.station_front_clientidtrafstat
        station_front_oktaurl               = var.station_front_oktaurl
        station_front_contextbackurl        = var.station_front_contextbackurl
        awslogs_group                       = aws_cloudwatch_log_group.station_front_cloudwatch_log.name
    }
}
