/** Station db with mariadb - Better to use RDS better performance
 but it's just for test that we build station db **/
/*module "station_db"{
     source = "./station_db"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
     subnets_id                     = [ data.aws_subnet.station_publicsubnet1.id]
     station_db_container_memory    = var.station_db_container_memory
     station_db_container_cpu       = var.station_db_container_cpu
     station_db_image               = var.station_db_image
     station_db_host_port           = var.station_db_host_port
     region                         = var.region
     task_role_arn                  = aws_iam_role.station_iam_role.arn
     execution_role_arn             = aws_iam_role.station_execution_role.arn
     station_db_root                = var.station_db_root
     station_db_databasename        = var.station_db_databasename
     station_db_username            = var.station_db_username
     station_db_password            = var.station_db_password
}*/

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
     station_domainname             = var.station_domainname
}


/** Station front with Nginx**/
/*module "station_front"{
     source = "./station_front"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
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
}*/

