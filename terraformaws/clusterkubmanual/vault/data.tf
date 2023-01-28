// Filter on vpc
data "aws_vpc" "station_vpc" {
  filter {
    name   = "tag:Name"
    values = ["station_vpc"]
  }
}

// Filter in private subnet 2
data "aws_subnet" "station_privatesubnet2" {

  filter {
    name   = "tag:Name"
    values = ["station_privatesubnet2"]
  }
}

# AWS Route 53 Private Zone
data "aws_route53_zone" "private" {
  name         = var.station_privatedomainname 
  private_zone = true
}

// Datasources
data "aws_ami" "ecs_optimized" {
  most_recent = true
  filter {
    name   = "name"
    values = ["*ecs-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

