resource "aws_alb" "station_front_alb"{
    name = "station-front-alb"

    subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ] 

    security_groups = [ aws_security_group.sg_station_front_alb.id ]

    tags = {
        Name = "station-front-alb"
        Application= var.application
    }


} 
