resource "aws_alb" "prometheus_alb"{
    name = "prometheus-alb"

    subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ] 

    security_groups = [ aws_security_group.sg_station_front_alb.id ]

    tags = {
        Name = "prometheus-alb"
        Application= var.application
        "ingress.k8s.aws/stack"    = "prometheus-group"
        "ingress.k8s.aws/resource" = "LoadBalancer"
        "elbv2.k8s.aws/cluster"    = "station-eks-cluster"
    }
}


resource "aws_alb_target_group" "prometheus_target_group" {
  name = "prometheus-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.station_vpc.id  
  target_type = "ip"
  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    port     = "80"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "prometheus-alb-target-group"
    Application= var.application
  }
}


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "prometheus_alb_listener" {
  load_balancer_arn =  aws_alb.prometheus_alb.id
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.prometheus_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "prometheus_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.prometheus_alb.dns_name
}
 
