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

