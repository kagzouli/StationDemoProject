resource "aws_elb" "station_front_alb"{
    name = "station_front_alb"

    subnets = var.public_subnets_id

    cross_zone_load_balancing   = true 


    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "TCP:9200"
        interval = 10
    }

    security_groups = [ aws_security_group.station_front.id ]

    tags = {
        Name = "station_front_alb"
        Application= var.application
    }


} 
