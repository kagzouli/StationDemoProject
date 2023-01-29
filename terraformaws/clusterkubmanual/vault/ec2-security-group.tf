# Load balancer
resource "aws_security_group" "kubernatesvaultlb-sg" {
  vpc_id      = data.aws_vpc.station_vpc.id 
  name        = "kubernatesvaultlb-sg"

  description = "Station LB security group"


  # Port for Vault
  # For test only 0.0.0.0/0. In real world company , we must put CIDR company
  ingress {
    from_port = 8200
    to_port = 8200
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernatesvaultlb-sg"
    Application= var.application
  }
}

# Load balancer
resource "aws_security_group" "kubernatesvaultec2-sg" {
  vpc_id      = data.aws_vpc.station_vpc.id 
  name        = "kubernatesvaultec2-sg"

  description = "Station EC2 security group"

  # For test only 0.0.0.0/0. In real world company , we must put CIDR company
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
    security_groups = [aws_security_group.kubernatesvaultlb-sg.id]
  }

  ingress {
    from_port = 8201
    to_port = 8201
    protocol = "tcp"
    security_groups = [aws_security_group.kubernatesvaultlb-sg.id]
  }

  

  # Egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernatesvaultec2-sg"
    Application= var.application
  }
}

