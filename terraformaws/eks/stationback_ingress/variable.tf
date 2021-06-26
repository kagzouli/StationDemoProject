variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_back_image"{
   type        = string
   description = "Image docker du station_back"
}

variable "station_back_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
}


variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}


variable "station_db_url_external"{
  type        = string
  description = "URL de la base de donnee"
}

variable "station_db_host_port"{
   type        = number
   description = "Port de station_db affiché à l'exterieur."
}

variable "station_db_username"{
  type        = string
  description = "Database username"
}

variable "station_db_password"{
  type        = string
  description = "Database password"
}


variable "station_redis_url_external"{
  type        = string
  description = "URL de redis"
}

variable "station_redis_host_port"{
   type        = number
   description = "Port de redis affiché à l'exterieur."
}

variable "station_redis_password"{
  type        = string
  description = "Database redis"
}

variable "station_back_url_external"{
  type        = string
  description = "URL du backend accessible"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public domaine name"
}

variable "station_back_host_port"{
   type        = number
   description = "Port de station_back affiché à l'exterieur."
}

