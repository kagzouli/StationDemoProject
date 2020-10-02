module "station_front"{
     source = "./station_front"
     application = var.application
     vpc_id = data.aws_vpc.station_vpc.id
     public_subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ]
     station_front_container_memory = var.station_front_container_memory
     station_front_container_cpu = var.station_front_container_cpu

}