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