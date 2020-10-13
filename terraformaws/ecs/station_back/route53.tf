# AWS Route 53 Zone
data "aws_route53_zone" "private" {
  name         = var.station_privatedomainname 
  private_zone = true
}

# AWS Route 53 Record
resource "aws_route53_record" "station_back_url_external" {
  zone_id      =  data.aws_route53_zone.private.zone_id
  name         = "${var.station_back_url_external}.${var.station_privatedomainname}" 
  type         = "CNAME"
  ttl          = "10"
  records      = [aws_alb.station_back_alb.dns_name]
 
}
