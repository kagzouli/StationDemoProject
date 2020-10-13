resource "aws_route53_zone" "private_dns" {
  name = var.station_privatedomainname

  vpc {
    vpc_id = aws_vpc.station_vpc.id
  }
}
