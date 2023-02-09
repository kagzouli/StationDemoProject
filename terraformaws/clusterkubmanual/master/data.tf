// Filter on vpc
data "aws_vpc" "station_vpc" {
  filter {
    name   = "tag:Name"
    values = ["station_vpc"]
  }
}

// Filter on public subnet 1
data "aws_subnet" "station_publicsubnet1" {

  filter {
    name   = "tag:Name"
    values = ["station_publicsubnet1"]
  }
}

// Filter on public subnet 2
data "aws_subnet" "station_publicsubnet2" {

  filter {
    name   = "tag:Name"
    values = ["station_publicsubnet2"]
  }
}

// Filter in private subnet 1
data "aws_subnet" "station_privatesubnet1" {

  filter {
    name   = "tag:Name"
    values = ["station_privatesubnet1"]
  }
}

// Filter in private subnet 2
data "aws_subnet" "station_privatesubnet2" {

  filter {
    name   = "tag:Name"
    values = ["station_privatesubnet2"]
  }
}

// Datasources
data "aws_ami" "ubuntu-linux" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

