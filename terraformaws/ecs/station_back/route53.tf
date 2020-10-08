# AWS Route 53 Zone
resource "aws_route53_zone" "primary" {
  name = "exaka.com"
}

# AWS Route 53 Record
resource "aws_route53_record" "station_back_url_external" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.station_back_url_external 
  type    = "CNAME"
  ttl     = "10"
  records = [aws_alb.station_back_alb.dns_name]
}
