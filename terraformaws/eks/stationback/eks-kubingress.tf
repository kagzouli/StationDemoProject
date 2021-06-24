resource "kubernetes_service_account" "alb-ingress" {
  metadata {
    name = "stationback-ingress"
    namespace = "stationback-deploy"
    labels = {
      "app.kubernetes.io/name" = "stationback-deploy"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "alb-ingress" {
  metadata {
    name = "stationback-ingress"
    labels = {
      "app.kubernetes.io/name" = "stationback-deploy"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "alb-ingress" {
  metadata {
    name = "stationback-ingress"
    labels = {
      "app.kubernetes.io/name" = "stationback-deploy"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "stationback-ingress"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "stationback-ingress"
    namespace = "stationback-deploy"
  }
}



resource "kubernetes_ingress" "app" {
  metadata {
    name      = "stationback-ingress"
    namespace = "stationback-deploy"
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "instance"
      "alb.ingress.kubernetes.io/group.name"      = "stationback-alb"
      "alb.ingress.kubernetes.io/group.order"     = 1
      "alb.ingress.kubernetes.io/load-balancer-name" = "stationback-eks-alb"
      "external-dns.alpha.kubernetes.io/hostname" = "${var.station_back_url_external}.${var.station_publicdomainname}"
      "alb.ingress.kubernetes.io/tags"            = "Name=stationback-alb, Application=${var.application}"
      "alb.ingress.kubernetes.io/security-groups" = aws_security_group.sg_station_back_alb.id
      "alb.ingress.kubernetes.io/subnets"         = "${data.aws_subnet.station_publicsubnet1.id} , ${data.aws_subnet.station_publicsubnet2.id}" 
      "alb.ingress.kubernetes.io/healthcheck-path" =  "/health"
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
