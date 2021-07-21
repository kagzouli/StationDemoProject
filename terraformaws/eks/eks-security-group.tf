# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "sg_station_front_alb" {
  name        = "station-front-alb"
  description = "Controle les acces a ALB"
  vpc_id      = data.aws_vpc.station_vpc.id 

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

