resource "aws_ecs_task_definition" "station_db_ecs_task_definition"{
    family                      = "station_db_ecs_task_definition"
    network_mode                = "awsvpc"
    requires_compatibilities    = ["FARGATE"]
    memory                      = var.station_db_container_memory
    cpu                         = var.station_db_container_cpu
    container_definitions       = data.template_file.station_db.rendered
    task_role_arn               = var.task_role_arn
    execution_role_arn          = var.execution_role_arn
 
    tags = {
        Name = "station-db-ecs-service"
        Application= var.application
    }

}

data "template_file"  "station_db"{
    template =  file("${path.module}/tasks-definition/station_db.json")

    vars = {
        station_db_image                   = var.station_db_image
        station_db_host_port               = var.station_db_host_port
        region                             = var.region
        awslogs_group                      = aws_cloudwatch_log_group.station_db_cloudwatch_log.name
    }
}
