# AWS Route 53 Zone
resource "aws_route53_zone" "primary" {
  name = var.station_domainname 
}

# AWS Route 53 Record
resource "aws_route53_record" "station_back_url_external" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.station_back_url_external}.${var.station_domainname}" 
  type    = "CNAME"
  ttl     = "10"
  records = [aws_alb.station_back_alb.dns_name]
 
}
