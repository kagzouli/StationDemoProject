module "station_front"{
     source = "./station_front"
     application                    = var.application
     vpc_id                         = data.aws_vpc.station_vpc.id
     public_subnets                 = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ]
     station_front_container_memory = var.station_front_container_memory
     station_front_container_cpu    = var.station_front_container_cpu
     station_front_image            = var.station_front_image
     station_front_host_port        = var.station_front_host_port
     region                         = var.region
     docker_registry_identifier     = data.aws_secretsmanager_secret.station_secret_manager.arn


}