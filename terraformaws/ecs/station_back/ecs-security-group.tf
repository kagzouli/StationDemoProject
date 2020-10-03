# Create security groups for tomcat.
resource "aws_security_group" "station_back" {
  name        = "station_back"
  description = "Station back"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
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
    Name = "station_back"
    Application= var.application
  }
}