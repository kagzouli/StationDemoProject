# AWS Route 53 Record
resource "aws_route53_record" "station_vault_url_internal" {
  zone_id      =  data.aws_route53_zone.public.zone_id
  name         = "${var.station_vault_url_external}.${var.station_publicdomainname}" 
  type         = "CNAME"
  ttl          = "10"
  records      = [aws_alb.station_vault_alb.dns_name]

}