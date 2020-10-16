# ALB Security Group: Edit to restrict access to the database 
resource "aws_security_group" "sg_station_db_ecs" {
  name        = "station-db-ecs"
  description = "Controle les acces a ECS"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.station_db_host_port 
    to_port     = var.station_db_host_port
    cidr_blocks = ["${var.cidr_block}"]
    description = "TCP request"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "station-db-ecs"
    Application= var.application
  }
}


# Traffic from the EC2
resource "aws_security_group" "station_db_c2_sg" {
  vpc_id      = var.vpc_id
  name        = "station-db-ec2-sg"

  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all to EC2"


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "station-db-ecs"
    Application= var.application
  }
}

