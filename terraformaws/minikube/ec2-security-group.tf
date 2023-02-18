resource "aws_security_group" "minikube_sg" {
  vpc_id      = data.aws_vpc.station_vpc.id 
  name        = "minikube-ec2-sg"

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
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  # Core DNS
  ingress {
    from_port = 53
    to_port = 53
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  ingress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }


  ingress {
    from_port = 2379
    to_port = 2381
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  # Weave
  ingress {
    from_port = 6783
    to_port = 6783
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }

  # Weave
  ingress {
    from_port = 6783
    to_port = 6784
    protocol = "udp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
  }



  ingress {
    from_port = 10250
    to_port = 10252
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }

  ingress {
    from_port = 8090
    to_port = 8091
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }

  ingress {
    from_port = 10255
    to_port = 10255
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }

  ingress {
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }

  # BGP
  ingress {
    from_port = 179
    to_port = 179
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }

  ingress {
    from_port = 5473 
    to_port = 5473 
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block , var.docker_cidr]
  }




  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minikube-sg"
    Application= var.application
  }
}

