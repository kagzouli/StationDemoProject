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
  records      = [kubernetes_service.stationback_service.load_balancer_ingress[0].hostname]

  depends_on = [kubernetes_service.stationback_service] 
}
