output "ingress_hostname" {
  value = kubernetes_service.stationback_service.load_balancer_ingress[0].hostname
}
