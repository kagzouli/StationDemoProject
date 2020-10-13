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

    cidr_block =  var.public_subnet1_cidr
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
  route_table_id         = aws_route_table.station_public1routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.station_internalgw.id
}

resource "aws_route_table_association" "station_routetablassoc_public1" {
  subnet_id      = aws_subnet.station_publicsubnet1.id
  route_table_id = aws_route_table.station_public1routetable.id
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

resource "aws_route_table" "station_public2routetable" {
  vpc_id = aws_vpc.station_vpc.id
  tags = {
     Name = "station_public2routetable",
     Application= var.application
  }
}

resource "aws_route" "station_public2" {
  route_table_id         =  aws_route_table.station_public2routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             =  aws_internet_gateway.station_internalgw.id
}

resource "aws_route_table_association" "station_routetablassoc_public2" {
  subnet_id      = aws_subnet.station_publicsubnet2.id
  route_table_id = aws_route_table.station_public2routetable.id
}



/*** Private subnet 1 **/
resource "aws_subnet" "station_privatesubnet1" {
    vpc_id = aws_vpc.station_vpc.id

    cidr_block             =  var.private_subnet1_cidr
    availability_zone      = var.az_zone1

    tags = {
       Name = "station_privatesubnet1",
       Application= var.application
    }
}

/*** NAT Gateway and EIP 1 **/
resource "aws_eip" "station_eip_natgateway1" {
  vpc = true
}

resource "aws_nat_gateway" "station_natgateway1" {
  depends_on = [
    aws_eip.station_eip_natgateway1
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.station_eip_natgateway1.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.station_publicsubnet1.id
  tags = {
      Name = "station_natgateway1"
      Application= var.application
  }
}

resource "aws_route_table" "station_natgateway1_routetable" {
  
  vpc_id = aws_vpc.station_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.station_natgateway1.id
  }

  tags = {
    Name = "station_natgateway1_routetable"
    Application= var.application
  }
}

resource "aws_route_table_association" "station_natgateway1_routeassoc" {
  depends_on = [
    aws_route_table.station_natgateway1_routetable
  ]

#Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.station_privatesubnet1.id

# Route Table ID
  route_table_id = aws_route_table.station_natgateway1_routetable.id
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

resource "aws_eip" "station_eip_natgateway2" {
  vpc = true
}

resource "aws_nat_gateway" "station_natgateway2" {
  depends_on = [
    aws_eip.station_eip_natgateway2
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.station_eip_natgateway2.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.station_publicsubnet2.id
  tags = {
      Name = "station_natgateway2"
      Application= var.application
  }
}
 
resource "aws_route_table" "station_natgateway2_routetable" {
  
  vpc_id = aws_vpc.station_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.station_natgateway2.id
  }

  tags = {
    Name = "station_natgateway2_routetable"
    Application= var.application
  }
}

resource "aws_route_table_association" "station_natgateway2_routeassoc" {
  depends_on = [
    aws_route_table.station_natgateway2_routetable
  ]

#Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.station_privatesubnet2.id

# Route Table ID
  route_table_id = aws_route_table.station_natgateway2_routetable.id
} 
