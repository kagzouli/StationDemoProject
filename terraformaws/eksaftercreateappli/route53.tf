# AWS Route 53 Zone
data "aws_route53_zone" "public" {
  name         = var.station_publicdomainname 
}

# AWS Route 53 Record
resource "aws_route53_record" "station_back_url_external" {
  zone_id      =  data.aws_route53_zone.public.zone_id
  name         = "${var.station_back_url_external}.${var.station_publicdomainname}" 
  type         = "CNAME"
  ttl          = "10"
  records      = [data.aws_alb.stationback_alb.dns_name]
 
}

resource "aws_route53_record" "station_front_url_external" {
  zone_id      =  data.aws_route53_zone.public.zone_id
  name         = "${var.station_front_url_external}.${var.station_publicdomainname}"
  type         = "CNAME"
  ttl          = "10"
  records      = [data.aws_alb.stationfront_alb.dns_name]

}

