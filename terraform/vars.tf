variable "region" {
  default     = "eu-west-3"
  type        = string
  description = "Region of the VPC"
}

variable "vpc_cidr_block" {
  default     = "12.0.0.0/24"
  type        = string
  description = "CIDR of the VPC"
}

variable "public_subnet1_cidr" {
    description = "CIDR for the Public Subnet1"
    default = "12.0.1.0/27"
}

variable "public_subnet2_cidr" {
    description = "CIDR for the Public Subnet2"
    default = "12.0.2.0/27"
}

variable "private_subnet1_cidr" {
    description = "CIDR for the Private Subnet1"
    default = "12.0.3.0/26"
}

variable "private_subnet2_cidr" {
    description = "CIDR for the Private Subnet2"
    default = "12.0.4.0/26"
}

variable "az_zone1" {
    description = "Availability zone 1"
    default = "eu-west-3a"
}

variable "az_zone2" {
    description = "Availability zone 1"
    default = "eu-west-3b"
}


variable "application"{ 
  default     = "STATION"
  type        = string
  description = "Application"
}
