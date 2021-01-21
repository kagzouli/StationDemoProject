/** Station back with Tomcat **/
module "station_back"{
     source = "./station_back"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
     station_back_url_external      = var.station_back_url_external
     public_subnets_id              = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ]
     private_subnets_id             = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ]
     station_back_container_memory  = var.station_back_container_memory
     station_back_container_cpu     = var.station_back_container_cpu
     station_back_image             = var.station_back_image
     station_back_host_port         = var.station_back_host_port
     station_back_count             = var.station_back_instance_count
     region                         = var.region
     task_role_arn                  = aws_iam_role.station_iam_role.arn
     execution_role_arn             = aws_iam_role.station_execution_role.arn
     context_db                     = "${var.station_db_url_external}.${var.station_privatedomainname}:${var.station_db_host_port}"
     station_db_username            = var.station_db_username
     station_db_password            = var.station_db_password
     station_publicdomainname       = var.station_publicdomainname
}


/** Station front with Nginx**/
module "station_front"{
     source = "./station_front"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
     station_front_url_external     = var.station_front_url_external
     public_subnets_id              = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ]
     private_subnets_id             = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ]
     station_front_container_memory = var.station_front_container_memory
     station_front_container_cpu    = var.station_front_container_cpu
     station_front_image            = var.station_front_image
     station_front_host_port        = var.station_front_host_port
     station_front_count            = var.station_front_instance_count
     region                         = var.region
     availability_zones             = "${var.az_zone1}, ${var.az_zone2}"
     task_role_arn                  = aws_iam_role.station_iam_role.arn
     execution_role_arn             = aws_iam_role.station_execution_role.arn
     station_publicdomainname       = var.station_publicdomainname
     station_front_clientidtrafstat = var.station_front_clientidtrafstat
     station_front_oktaurl          = var.station_front_oktaurl
     station_front_contextbackurl   = "http://${var.station_back_url_external}.${var.station_publicdomainname}:${var.station_back_host_port}" 
}

