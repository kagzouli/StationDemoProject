variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}

variable "stationkubenamespace"{
  type        =  string
  description = "Application"
}

variable "nbNodeInstanceEks"{
  type        =  number
  description = "Nombre nodes cluster station EKS"
}

variable "az_zone1" {
    type        =  string
    description =  "Availability zone 1"
}

variable "az_zone2" {
    type        =  string
    description =  "Availability zone 2"
}


variable "station_back_host_port"{
   type        = number
   description = "Port de station_back affiché à l'exterieur."
}

variable "station_back_url_external"{
  type        = string
  description = "URL du backend accessible"
}



variable "station_front_host_port"{
   type        = number
   description = "Port de station_front affiché à l'exterieur."
}

variable "station_front_url_external"{
  type        = string
  description = "URL du site web station"
}


variable "station_publicdomainname" {
    type        =  string
    description = "Public Domaine name"
}

variable "type_kind_helm_back" {
    type        =  string
    description = "Type kind of helm station back. Can be Ingress or TargetGroupBinding"
}

variable "type_kind_helm_front" {
    type        =  string
    description = "Type kind of helm station front. Can be Ingress or TargetGroupBinding"
}