resource "aws_elb" "station_front_alb"{
    name = "station-front-alb"

    subnets = var.public_subnets_id

    cross_zone_load_balancing   = true 

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = 80
        instance_protocol = "http"
    }

    listener {
        lb_port = 8200
        lb_protocol = "tcp"
        instance_port = 8200
        instance_protocol = "tcp"
    }  

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
