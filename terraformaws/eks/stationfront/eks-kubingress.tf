resource "kubernetes_ingress" "app" {
  metadata {
    name      = "stationfront-ingress"
    namespace = "stationfront-deploy"
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/load-balancer-name" = "stationfront-eks-alb"
      "external-dns.alpha.kubernetes.io/hostname" = "${var.station_front_url_external}.${var.station_publicdomainname}"
    }
    labels = {
        "app" = "stationfront"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.stationfront_service.metadata[0].name
            service_port = kubernetes_service.stationfront_service.spec[0].port[0].port
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.stationfront_service]
}
