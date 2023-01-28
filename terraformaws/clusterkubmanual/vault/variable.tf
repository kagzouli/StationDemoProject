variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_vault_url_internal"{
  type        = string
  description = "debut url Vault réseaux privé"
}

variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}
