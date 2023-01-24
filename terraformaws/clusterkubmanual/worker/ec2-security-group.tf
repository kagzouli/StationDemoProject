resource "aws_security_group" "kubworkermanual_sg" {
  vpc_id      = data.aws_vpc.station_vpc.id 
  name        = "kubernateworkermanual-ec2-sg"

  description = "Station EC2 security group"


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  ingress {
    from_port = 10250
    to_port = 10252
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  ingress {
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }




  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubmasterworker-sg"
    Application= var.application
  }
}

