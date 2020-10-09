# AWS Route 53 Zone
data "aws_route53_zone" "public" {
  name = var.station_domainname 
}

# AWS Route 53 Record
resource "aws_route53_record" "station_db_url_external" {
  zone_id =  data.aws_route53_zone.public.zone_id
  name    = "${var.station_db_url_external}.${var.station_domainname}" 
  type    = "CNAME"
  ttl     = "10"
  records = [aws_alb.station_front_alb.dns_name]
 
}
