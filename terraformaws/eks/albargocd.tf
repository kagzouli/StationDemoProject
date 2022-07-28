resource "aws_alb" "argocd_alb"{
    name = "argocd-alb"

    subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ] 

    security_groups = [ aws_security_group.sg_station_front_alb.id ]

    tags = {
        Name = "argocd-alb"
        Application= var.application
        "ingress.k8s.aws/stack"    = "argocd-group"
        "ingress.k8s.aws/resource" = "LoadBalancer"
        "elbv2.k8s.aws/cluster"    = "station-eks-cluster"
    }
}


resource "aws_alb_listener" "argocd_http_target_groups" {
    load_balancer_arn = aws_alb.argocd_alb.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
    type = "redirect"
    redirect {

      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"

    }

  }

}

resource "aws_alb_target_group" "argocd_target_group" {
  name = "argocd-target-group"
  port = 443 
  protocol = "HTTPS"
  vpc_id = data.aws_vpc.station_vpc.id 
  target_type = "ip"
  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTPS"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "argocd-alb-target-group"
    Application= var.application
  }
}


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "argocd_alb_listener" {
  load_balancer_arn = aws_alb.argocd_alb.id
  port = 443
  protocol = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.public_domain.arn

  default_action {
    target_group_arn = aws_alb_target_group.argocd_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "argocd_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.argocd_alb.dns_name
}
 
