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


data "aws_acm_certificate" "public_domain" {
  domain      = var.station_publicdomainname
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

