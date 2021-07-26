variable "region" {
  type        = string
  description = "Region of the VPC"
}


variable "application"{ 
  type        =  string
  description = "Application"
  default     = "STATION"
}


variable "station_db_password" {
  type        = string
  description = "Database password"
}

variable "station_db_root_password" {
  type        = string
  description = "Database root password"
}

locals {
  station_credentials = {
    stationdbrootpassword  = var.station_db_root_password
    stationdbpassword      = var.station_db_password
  }
}

variable "kms_principal" {
  default = [
    "arn:aws:iam::794637260409:root"
  ]
}
