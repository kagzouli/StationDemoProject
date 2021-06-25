resource "kubernetes_ingress" "app" {
  metadata {
    name      = "stationback-ingress-app2"
    namespace = "stationback-deploy"
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/group.name"      = "stationback-alb"
      "alb.ingress.kubernetes.io/group.order"     = 1
      "alb.ingress.kubernetes.io/tags"            = "Name=stationback-alb, Application=${var.application}"
      "alb.ingress.kubernetes.io/security-groups" = aws_security_group.sg_station_back_alb.id
      "alb.ingress.kubernetes.io/healthcheck-path" =  "/health"
      "alb.ingress.kubernetes.io/listen-ports"   =  "[{\"HTTP\": 8080}]"
      "alb.ingress.kubernetes.io/load-balancer-name" = "stationback-eks-alb"
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
