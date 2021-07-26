variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{ 
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "az_zone1" {
    type        =  string
    description =  "Availability zone 1"
}

variable "az_zone2" {
    type        =  string
    description =  "Availability zone 2"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public domaine name"
}

variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}


variable "station_back_container_memory"{
   type        = number
   description = "station Back container memory"
}

variable "station_back_container_cpu"{
   type        = number
   description = "station Back container cpu"
}

variable "station_back_image"{
   type        = string
   description = "Image docker du station_back"
}

variable "station_back_host_port"{
   type        = number
   description = "Port de station_back affiché à l'exterieur."
}

variable "station_back_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
}


variable "station_back_url_external"{
  type        = string
  description = "URL du backend accessible"
}


variable "station_front_container_memory"{
   type        = number
   description = "station Front container memory"
}

variable "station_front_container_cpu"{
   type        = number
   description = "station Front container cpu"
}

variable "station_front_image"{
   type        = string
   description = "Image docker du station_front"
}

variable "station_front_host_port"{
   type        = number
   description = "Port de station_front affiché à l'exterieur."
}

variable "station_front_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
}

variable "station_front_url_external"{
  type        = string
  description = "URL du site station"
}


variable "station_front_clientidtrafstat" {
  type        = string
  description = "Client ID for station front"
}

variable "station_front_oktaurl" {
  type        = string
  description = "Okta URL for station front"
}


variable "station_db_url_external"{
  type        = string
  description = "URL de la base de donnee"
}

variable "station_db_host_port"{
   type        = number
   description = "Port de station_db affiché à l'exterieur."
}

variable "station_db_databasename" {
  type        = string
  description = "Database name"
}

variable "station_db_username" {
  type        = string
  description = "Database username"
}

variable "station_redis_url_external"{
  type        = string
  description = "URL de redis"
}

variable "station_redis_host_port"{
   type        = number
   description = "Port de redis affiché à l'exterieur."
}

variable "station_redis_password" {
  type        = string
  description = "Redis password"
}
