variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{ 
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_db_container_memory"{
   type        = number
   description = "station Db container memory"
}

variable "station_db_container_cpu"{
   type        = number
   description = "station Db container cpu"
}

variable "station_db_image"{
   type        = string
   description = "Image docker du station_db"
}

variable "station_db_host_port"{
   type        = number
   description = "Port de station_db affiché à l'exterieur."
}


variable "station_back_container_memory"{
   type        = number
   description = "station Back container memory"
}

variable "station_back_container_cpu"{
   type        = number
   description = "station Back container cpu"
}

variable "station_back_image"{
   type        = string
   description = "Image docker du station_back"
}

variable "station_back_host_port"{
   type        = number
   description = "Port de station_back affiché à l'exterieur."
}



variable "station_front_container_memory"{
   type        = number
   description = "station Front container memory"
}

variable "station_front_container_cpu"{
   type        = number
   description = "station Front container cpu"
}

variable "station_front_image"{
   type        = string
   description = "Image docker du station_front"
}

variable "station_front_host_port"{
   type        = number
   description = "Port de station_front affiché à l'exterieur."
}


