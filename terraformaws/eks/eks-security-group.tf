# ALB Security Group: Edit to restrict the backend
resource "aws_security_group" "sg_station_back_alb" {
  name        = "station-back-alb"
  description = "Controle les acces au back REST"
  vpc_id      = data.aws_vpc.station_vpc.id 

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

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "https request"
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

