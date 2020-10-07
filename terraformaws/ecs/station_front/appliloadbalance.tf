resource "aws_alb" "station_front_alb"{
    name = "station-front-alb"

    subnets = var.public_subnets_id

    security_groups = [ aws_security_group.sg_station_front_alb.id ]

    tags = {
        Name = "station_front_alb"
        Application= var.application
    }


} 

resource "aws_alb_target_group" "station_front_target_group" {
  name = "station-front-target-group"
  port = var.station_front_host_port 
  protocol = "HTTP"
  vpc_id = var.vpc_id 
  target_type = "ip"
  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/station-angular4-poc/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "station-front-alb-target-group"
    Application= var.application
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "station_front_alb_listener" {
  load_balancer_arn = aws_alb.station_front_alb.id
  port = var.station_front_host_port
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.station_front_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "station_front_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.station_front_alb.dns_name
}
