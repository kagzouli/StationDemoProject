resource "kubernetes_deployment" "stationback_deployment" {
  metadata {
    name      = "stationback-deploy"
    namespace = "stationback-deploy"
    labels    = {
      app = "stationback"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "stationback"
      }
    }

    template {
      metadata {
        labels = {
          app = "stationback"
        }
      }

      spec {
        container {
          image = var.station_back_image
          name  = "stationback"

          port {
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [aws_eks_fargate_profile.aws_eks_fargate]
}

resource "kubernetes_service" "stationback_service" {
  metadata {
    name      = "stationback-deploy"
    namespace = "stationback-deploy"
  }
  spec {
    selector = {
      app = kubernetes_deployment.stationback_deployment.metadata[0].labels.app
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.stationback_deployment]
}
