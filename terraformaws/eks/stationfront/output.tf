output "ingress_hostnamefront" {
  value = kubernetes_service.stationfront_service.load_balancer_ingress[0].hostname
}
