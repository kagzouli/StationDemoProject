variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "stationkubenamespace"{
  type        =  string
  description = "Application"
}

variable "nbNodeInstanceEks"{
  type        =  number
  description = "Nombre nodes cluster station EKS"
}

variable "az_zone1" {
    type        =  string
    description =  "Availability zone 1"
}

variable "az_zone2" {
    type        =  string
    description =  "Availability zone 2"
}



variable "station_front_host_port"{
   type        = number
   description = "Port de station_front affiché à l'exterieur."
}

