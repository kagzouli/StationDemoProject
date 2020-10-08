# Create security groups for database (Better to use RDS but it's for test).
resource "aws_security_group" "station_db" {
  name        = "station-db"
  description = "Station Database"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
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
    Name = "station-db"
    Application= var.application
  }
}
