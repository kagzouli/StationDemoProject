variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_vault_url_external"{
  type        = string
  description = "debut url Vault réseaux public"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public Domaine name"
}
