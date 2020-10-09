resource "aws_alb" "station_db_alb"{
    name = "station-db-alb"

    subnets = var.subnets_id

    security_groups = [ aws_security_group.sg_station_db_alb.id ]

    tags = {
        Name = "station-db-alb"
        Application= var.application
    }


} 

resource "aws_alb_target_group" "station_db_target_group" {
  name = "station-db-target-group"
  port = var.station_db_host_port 
  protocol = "TCP"
  vpc_id = var.vpc_id 
  target_type = "ip"
  tags = {
    Name = "station-db-alb-target-group"
    Application= var.application
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "station_db_alb_listener" {
  load_balancer_arn = aws_alb.station_db_alb.id
  port = var.station_db_host_port
  protocol = "TCP"
  default_action {
    target_group_arn = aws_alb_target_group.station_db_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "station_db_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.station_db_alb.dns_name
}
