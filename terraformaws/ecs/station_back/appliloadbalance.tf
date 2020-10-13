resource "aws_alb" "station_back_alb"{
    name = "station-back-alb"

    subnets = var.public_subnets_id

    security_groups = [ aws_security_group.sg_station_back_alb.id ]

    tags = {
        Name = "station-back-alb"
        Application= var.application
    }


} 

resource "aws_alb_target_group" "station_back_target_group" {
  name = "station-back-target-group"
  port = var.station_back_host_port 
  protocol = "HTTP"
  vpc_id = var.vpc_id 
  target_type = "ip"
  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/StationDemoSecureWeb/health/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "station-back-alb-target-group"
    Application= var.application
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "station_back_alb_listener" {
  load_balancer_arn = aws_alb.station_back_alb.id
  port = var.station_back_host_port
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.station_back_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "station_back_dns_lb" {
  description = "DNS load balancer back end"
  value = aws_alb.station_back_alb.dns_name
}

