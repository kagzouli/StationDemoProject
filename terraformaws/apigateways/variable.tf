variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public Domaine name"
}

