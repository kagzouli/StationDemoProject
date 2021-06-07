resource "kubernetes_deployment" "stationfront_deployment" {
  metadata {
    name      = "stationfront-deploy"
    namespace = "stationfront-deploy"
    labels    = {
      app = "stationfront"
    }

  }

  spec {
    replicas = var.station_front_instance_count 

    selector {
      match_labels = {
        app = "stationfront"
      }
    }

    template {
      metadata {
        labels = {
          app = "stationfront"
        }
      }

      spec {
        container {
          image = var.station_front_image
          name  = "stationfront"

          port {
            container_port = 80
          }

          env {
            name  = "AWS_REGION"
            value = var.region
          }
 
          env {
            name  = "CLIENT_ID_TRAF_STAT"
            value = var.station_front_clientidtrafstat 
          }
 
          env {
            name  = "OKTA_URL"
            value = var.station_front_oktaurl 
          }
           
          env { 
            name  = "CONTEXT_BACK_URL" 
            value = "http://${var.station_back_url_external}.${var.station_publicdomainname}:${var.station_back_host_port}"
          }
          
        }
      }
    }
  }

  depends_on = [aws_eks_fargate_profile.aws_eks_fargatefront]
}

resource "kubernetes_service" "stationfront_service" {
  metadata {
    name      = "stationfrontservice"
    namespace = "stationfront-deploy"
    
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "${var.station_front_url_external}.${var.station_publicdomainname}"
    }

  }
  spec {
    selector = {
      app = kubernetes_deployment.stationfront_deployment.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.stationfront_deployment]
}
