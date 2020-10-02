resource "aws_ecs_task_definition" "station_front_ecs_task_definition"{

    family                      = "station_front_ecs_task_definition"
    network_mode                = "awsvpc"
    memory                      = var.station_front_container_memory
    cpu                         = var.station_front_container_cpu
    container_definitions       = data.template_file.station_front.rendered

    tags = {
        Name = "station_front_ecs_service"
        Application= var.application
    }

}

data "template_file"  "station_front"{
    template =  file("${path.module}/tasks-definition/station_front.json")

    vars = {
        station_front_image                 = var.station_front_image
        station_front_host_port             = var.station_front_host_port
        region                              = var.region
        awslogs_group                       = aws_cloudwatch_log_group.centralized_java_log_group.name
        secret_arn                          = data.aws_secretsmanager_secret.secrets-manager.arn

    }
}