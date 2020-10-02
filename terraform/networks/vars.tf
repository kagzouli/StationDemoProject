variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR of the VPC"
}

variable "public_subnet1_cidr" {
    type        = "string"
    description = "CIDR for the Public Subnet1"
}

variable "public_subnet2_cidr" {
    type        = "string"
    description = "CIDR for the Public Subnet2"
}

variable "private_subnet1_cidr" {
    type        = "string"
    description = "CIDR for the Private Subnet1"
}

variable "private_subnet2_cidr" {
    type        = "string"
    description = "CIDR for the Private Subnet2"
}

variable "az_zone1" {
    type        = "string"
    description = "Availability zone 1"
}

variable "az_zone2" {
    type        = "string"
    description = "Availability zone 1"
}


variable "application"{ 
  type        = string
  description = "Application"
  default     = "STATION"
}
