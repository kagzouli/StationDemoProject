resource "aws_ecs_task_definition" "station_back_ecs_task_definition"{
    family                      = "station_back_ecs_task_definition"
    network_mode                = "awsvpc"
    requires_compatibilities    = ["FARGATE"]
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
        station_back_image                  = var.station_back_image
        station_back_host_port              = var.station_back_host_port
        station_back_container_port         = var.station_back_container_port
        context_db                          = var.context_db
        station_db_username                 = var.station_db_username
        station_db_password                 = var.station_db_password
        region                              = var.region
        awslogs_group                       = aws_cloudwatch_log_group.station_back_cloudwatch_log.name
    }
}
