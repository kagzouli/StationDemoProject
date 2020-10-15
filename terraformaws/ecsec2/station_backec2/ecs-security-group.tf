# ALB Security Group: Edit to restrict access to the back end REST
resource "aws_security_group" "sg_station_back_alb" {
  name        = "station-back-alb"
  description = "Controle les acces au back REST"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.station_back_host_port 
    to_port     = var.station_back_host_port
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
    Name = "station-back-alb"
    Application= var.application
  }
}

# Traffic to the ECS cluster from the ALB back
resource "aws_security_group" "sg_station_back_ecs" {
  name        = "station-back-ecs"
  description = "Controle les acces a ECS"
  vpc_id      = var.vpc_id
  ingress {
    protocol = "tcp"
    from_port = var.station_back_host_port
    to_port = var.station_back_host_port
    security_groups = [aws_security_group.sg_station_back_alb.id]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "station-back-ecs"
    Application= var.application
  }
}
