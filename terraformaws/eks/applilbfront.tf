resource "aws_alb" "station_front_alb"{
    name = "station-front-alb"

    subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ] 

    security_groups = [ aws_security_group.sg_station_front_alb.id ]

    tags = {
        Name = "station-front-alb"
        Application= var.application
        "ingress.k8s.aws/stack"    = "station-front-group"
        "ingress.k8s.aws/resource" = "LoadBalancer"
        "elbv2.k8s.aws/cluster"    = "station-eks-cluster"
    }
}

resource "aws_alb_target_group" "station_front_target_group" {
  name = "station-front-target-group"
  port = var.station_front_host_port 
  protocol = "HTTP"
  vpc_id = data.aws_vpc.station_vpc.id 
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

  count = (var.type_kind_helm_front == "TargetGroupBinding") ? 1:0

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

  count = (var.type_kind_helm_front == "TargetGroupBinding") ? 1:0

  default_action {
    target_group_arn = aws_alb_target_group.station_front_target_group[0].id
    type = "forward"
  }
}


# output nginx public ip
output "station_front_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.station_front_alb.dns_name
}
 
