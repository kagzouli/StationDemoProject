variable "application"{ 
  type        =  string
  default     =  "stationdb"
  description = "Nom application"
}

variable "az_zone1" {
    type        =  string
    description =  "Availability zone 1"
}

variable "az_zone2" {
    type        =  string
    description =  "Availability zone 2"
}

variable "region" {
  type        = string
  description = "Region"
}
