module "station_front"{
     source = "./station_front"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
     subnets_id                     = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ]
     station_front_container_memory = var.station_front_container_memory
     station_front_container_cpu    = var.station_front_container_cpu
     station_front_image            = var.station_front_image
     station_front_host_port        = var.station_front_host_port
     region                         = var.region
     task_role_arn                  = aws_iam_role.station_front_iam_role.arn
     execution_role_arn             = aws_iam_role.station_front_execution_role.arn
}