/*** VPC **/
resource "aws_vpc" "station_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "station_vpc",
    Application= var.application
  }
}

/*** Internal Gateway **/
resource "aws_internet_gateway" "station_internalgw" {
  vpc_id = aws_vpc.station_vpc.id

  tags = {
    Name = "station_internalgateway",
    Application= var.application
  }
}

/*** Public Subnet 1 **/
resource "aws_subnet" "station_publicsubnet1" {
    vpc_id = aws_vpc.station_vpc.id

    cidr_block =  var.public_subnetta1_cidr
    availability_zone = var.az_zone1

    tags = {
       Name = "station_publicsubnet1",
       Application= var.application
    }
}

resource "aws_route_table" "station_public1routetable" {
  vpc_id = aws_vpc.station_vpc.id
  tags = {
     Name = "station_public1routetable",
     Application= var.application
  }
}

resource "aws_route" "station_public1" {
  route_table_id         = "${aws_route_table.station_public1routetable.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.station_internalgw.id}"
}

resource "aws_route_table_association" "station_routetablassoc_public1" {
  subnet_id      = "${aws_subnet.station_publicsubnet1.id}"
  route_table_id = "${aws_route_table.station_public1routetable.id}"
}




/*** Public subnet 2 **/
resource "aws_subnet" "station_publicsubnet2" {
    vpc_id = aws_vpc.station_vpc.id

    cidr_block =  var.public_subnet2_cidr
    availability_zone = var.az_zone2

    tags = {
       Name = "station_publicsubnet2",
       Application= var.application
    }
}

/*** Private subnet 1 **/
resource "aws_subnet" "station_privatesubnet1" {
    vpc_id = aws_vpc.station_vpc.id

    cidr_block =  var.private_subnet1_cidr
    availability_zone = var.az_zone1

    tags = {
       Name = "station_privatesubnet1",
       Application= var.application
    }
}

/*** Private subnet 2 **/
resource "aws_subnet" "station_privatesubnet2" {
    vpc_id = aws_vpc.station_vpc.id

    cidr_block =  var.private_subnet2_cidr
    availability_zone = var.az_zone2

    tags = {
       Name = "station_privatesubnet2",
       Application= var.application
    }
}


