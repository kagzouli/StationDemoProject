resource "aws_alb" "station_vault_alb"{
    name = "station-vault-alb"

    subnets = [ data.aws_subnet.station_publicsubnet1.id , data.aws_subnet.station_publicsubnet2.id ] 

    security_groups = [ aws_security_group.kubernatesvaultlb-sg.id ]

    tags = {
        Name = "station-vault-alb"
        Application= var.application
    }
}

resource "aws_alb_target_group" "station_vault_target_group" {
  name = "station-vault-target-group"
  port = 8200
  protocol = "HTTP"
  vpc_id = data.aws_vpc.station_vpc.id 
  target_type = "instance"
  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "station-vault-target-group"
    Application= var.application
  }
}

resource "aws_lb_target_group_attachment" "station_vault_target_group_attach" {
  target_group_arn = aws_alb_target_group.station_vault_target_group.arn
  target_id        = aws_instance.kubernatevaultonprem.id
  port             = 8200
}


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "station_vault_alb_listener" {
  load_balancer_arn = aws_alb.station_vault_alb.id
  port = 8200
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.station_vault_target_group.id
    type = "forward"
  }
}


# output nginx public ip
output "station_vault_dns_lb" {
  description = "DNS load balancer Vault"
  value = aws_alb.station_vault_alb.dns_name
}
 
