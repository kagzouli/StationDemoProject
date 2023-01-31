# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "sg_station_front_alb" {
  name        = "station-front-alb"
  description = "Controle les acces a ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.station_front_host_port 
    to_port     = var.station_front_host_port
    cidr_blocks = ["0.0.0.0/0"]
    description = "http request"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "station-front-alb"
    Application= var.application
  }
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "sg_station_front_ecs" {
  name        = "station-front-ecs"
  description = "Controle les acces a ECS"
  vpc_id      = var.vpc_id
  ingress {
    protocol = "tcp"
    from_port = var.station_front_host_port
    to_port = var.station_front_host_port
    security_groups = [aws_security_group.sg_station_front_alb.id]
  }
  ingress {
    protocol = "tcp"
    from_port = var.station_front_container_port
    to_port = var.station_front_container_port
    security_groups = [aws_security_group.sg_station_front_alb.id]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "station-front-ecs"
    Application= var.application
  }
}
