resource "aws_ecs_task_definition" "station_back_ecs_task_definition"{
    requires_compatibilities = ["FARGATE"]
    family                      = "station_back_ecs_task_definition"
    network_mode                = "awsvpc"
    memory                      = var.station_back_container_memory
    cpu                         = var.station_back_container_cpu
    container_definitions       = data.template_file.station_back.rendered
    task_role_arn               = var.task_role_arn
    execution_role_arn          = var.execution_role_arn
 
    tags = {
        Name = "station_back_ecs_service"
        Application= var.application
    }

}

data "template_file"  "station_back"{
    template =  file("${path.module}/tasks-definition/station_back.json")

    vars = {
        station_back_image                 = var.station_back_image
        station_back_host_port             = var.station_back_host_port
        region                              = var.region
        awslogs_group                       = aws_cloudwatch_log_group.station_back_cloudwatch_log.name
    }
}