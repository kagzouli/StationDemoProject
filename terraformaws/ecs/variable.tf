variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{ 
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_front_container_memory"{
   type        = string
   description = "station Front container memory"
}

variable "station_front_container_cpu"{
   type        = string
   description = "station Front container cpu"
}

variable "station_front_image"{
   type        = string
   description = "Image docker du station_front"
}

variable "station_front_host_port"{
   type        = string
   description = "Port de station_front affiché à l'exterieur."
}

locals {
  docker_registry_identification = {
    username = "test"
    password = "test"
  }
}

