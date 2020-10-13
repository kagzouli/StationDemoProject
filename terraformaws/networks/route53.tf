resource "aws_route53_zone" "private_dns" {
  name = var.private_station_domainname

  vpc {
    vpc_id = aws_vpc.station_vpc.id
  }
}
