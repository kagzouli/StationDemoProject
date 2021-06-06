rlb.ingress.kubernetes.io/schemeesource "kubernetes_ingress" "app" {
  metadata {
    name      = "stationback-ingress"
    namespace = "stationback"
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "kubernetes.io/cluster/station-eks"         = "shared"
    }
    labels = {
        "app" = "stationback"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.stationback_service.metadata[0].name
            service_port = kubernetes_service.stationback_service.spec[0].port[0].port
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.stationback_service]
}
