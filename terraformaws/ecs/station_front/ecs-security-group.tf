# Create security groups for nginx-front.
resource "aws_security_group" "station_front" {
  name        = "station_front"
  description = "Station front"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
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
    Name = "station_front"
    Application= var.application
  }
}