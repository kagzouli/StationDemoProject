module "station_front"{
     source = "./station_front"
     application = var.application
     public_subnet1_id= data.aws_subnet.station_publicsubnet1.id
     public_subnet2_id= data.aws_subnet.station_publicsubnet2.id
}