# AWS Route 53 Record
resource "aws_route53_record" "station_vault_url_internal" {
  zone_id      =  data.aws_route53_zone.private.zone_id
  name         = "${var.station_vault_url_internal}.${var.station_privatedomainname}" 
  type         = "CNAME"
  ttl          = "10"
  records      = [aws_instance.kubernatevaultonprem.private_dns]

}