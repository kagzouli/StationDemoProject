resource "kubernetes_deployment" "stationback_deployment" {
  metadata {
    name      = "stationback-deploy"
    namespace = "stationback-deploy"
    labels    = {
      app = "stationback"
    }
  }

  spec {
    replicas = var.station_back_instance_count 

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

          env {
            name  = "AWS_REGION"
            value = var.region
          }
 
          env {
            name  = "DB_TRAFSTAT_URL"
            value = "jdbc:mysql://${var.station_db_url_external}.${var.station_privatedomainname}:${var.station_db_host_port}/StationDemoDb?connectTimeout=0"
          }
 
          env {
            name  = "DB_TRAFSTAT_MAXACTIVE"
            value = "20"
          }
           
          env { 
            name  = "DB_TRAFSTAT_USERNAME" 
            value = var.station_db_username 
          }

          env {
             name  = "DB_TRAFSTAT_PASSWORD"
             value = var.station_db_password
          } 
           
          env {
             name  = "REDIS_HOSTNAME"
             value = "${var.station_redis_url_external}.${var.station_privatedomainname}" 
          }
           
          env {
             name  =  "REDIS_PORT"
             value =  var.station_redis_host_port
          }
           
          env {
             name  = "REDIS_PASS"
             value = var.station_redis_password
          }
           
          env {
               name  =  "REDIS_USESSL"
               value =  "true"
          }
          
        }
      }
    }
  }

  depends_on = [aws_eks_fargate_profile.aws_eks_fargate]
}

resource "kubernetes_service" "stationback_service" {
  metadata {
    name      = "stationbackservice"
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

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.stationback_deployment]
}
