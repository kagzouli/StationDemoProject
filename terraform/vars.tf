variable "region" {
  default     = "eu-west-3"
  type        = string
  description = "Region of the VPC"
}

variable "cidr_block" {
  default     = "12.0.0.0/25"
  type        = string
  description = "CIDR of the VPC"
}

variable "application"{ 
  default     = "STATION"
  type        = string
  description = "Application"
}
