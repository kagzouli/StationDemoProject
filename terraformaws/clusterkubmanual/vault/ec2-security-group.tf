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

