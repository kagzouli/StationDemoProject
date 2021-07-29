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

// Secret manager for Station 
data "aws_secretsmanager_secret" "station_secretmanager" {
  name = "stationsec-secretmanager"
}

data "aws_secretsmanager_secret_version" "station_vers_secretmanager" {
  secret_id = data.aws_secretsmanager_secret.station_secretmanager.id
}

