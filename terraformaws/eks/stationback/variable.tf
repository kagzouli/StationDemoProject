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
