variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "station_front_image"{
   type        = string
   description = "Image docker du station_front"
}

variable "station_front_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_front"
}


variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}


variable "station_front_url_external"{
  type        = string
  description = "URL du front accessible"
}

variable "station_back_url_external"{
  type        = string
  description = "URL du backend accessible"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public domaine name"
}

variable "station_front_host_port"{
   type        = number
   description = "Port de station_front affiché à l'exterieur."
}

variable "station_back_host_port"{
   type        = number
   description = "Port de station_back affiché à l'exterieur."
}

variable "station_front_clientidtrafstat" {
  type        = string
  description = "Client ID for station front"
}

variable "station_front_oktaurl" {
  type        = string
  description = "Okta URL for station front"
}

