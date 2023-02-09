variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "docker_cidr"{
  type        =  string
  description =  "Docker CIDR"
  default     =  "172.17.0.0/16"
}

