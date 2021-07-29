variable "application"{ 
  type        =  string
  default     =  "stationdb"
  description = "Nom application"
}

variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}

variable "station_redis_host_port"{
   type        = number
   description = "Port de station redis affiché à l'exterieur."
}

variable "station_redis_clusterbus_port"{
   type        = number
   description = "Port de station redis cluster bus."
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


variable "station_redis_count"{
  type        = number
  description = "Nombre d'instances de base."
}

variable "station_redis_instance_type"{
  type        = string
  description = "Type d'instance DB"
}

variable "station_redis_url_external"{
  type        = string
  description = "URL Redis"
}

