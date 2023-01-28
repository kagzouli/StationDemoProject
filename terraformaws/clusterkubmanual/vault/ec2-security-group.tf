resource "aws_security_group" "kubvaultonprem_sg" {
  vpc_id      = data.aws_vpc.station_vpc.id 
  name        = "kubernatesvaultonprem-ec2-sg"

  description = "Station EC2 security group"


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # Port for Vault
  ingress {
    from_port = 8200
    to_port = 8200
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  ingress {
    from_port = 8201
    to_port = 8201
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  # Egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubvaultonprem-sg"
    Application= var.application
  }
}

