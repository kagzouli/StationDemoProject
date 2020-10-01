resource "aws_vpc" "station_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "station_vpc",
    Application= var.application
  }
}

/*
  Public Subnet 1
*/
resource "aws_subnet" "station_publicsubnet1" {
    vpc_id = "${aws_vpc.station_vpc.id}"

    cidr_block =  var.public_subnet1_cidr
    availability_zone = var.az_zone1

    tags = {
       Name = "station_publicsubnet1",
       Application= var.application
    }
}

/*
  Public Subnet 2
*/
resource "aws_subnet" "station_publicsubnet2" {
    vpc_id = "${aws_vpc.station_vpc.id}"

    cidr_block =  var.public_subnet2_cidr
    availability_zone = var.az_zone2

    tags = {
       Name = "station_publicsubnet2",
       Application= var.application
    }
}

/*
  Private Subnet 1
*/
resource "aws_subnet" "station_privatesubnet1" {
    vpc_id = "${aws_vpc.station_vpc.id}"

    cidr_block =  var.private_subnet1_cidr
    availability_zone = var.az_zone1

    tags = {
       Name = "station_privatesubnet1",
       Application= var.application
    }
}

/*
  Private subnet 2
*/
resource "aws_subnet" "station_privatesubnet2" {
    vpc_id = "${aws_vpc.station_vpc.id}"

    cidr_block =  var.private_subnet2_cidr
    availability_zone = var.az_zone2

    tags = {
       Name = "station_privatesubnet2",
       Application= var.application
    }
}


