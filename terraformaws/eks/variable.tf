variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}


variable "nbNodeInstanceEks"{
  type        =  number
  description = "Nombre nodes cluster station EKS"
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


variable "shared_namespace" {
    type        =  string
    description = "Nom du sharepoint pour les outils communs"
}

variable "node_capacity_type"{
    type        = string
    description = "Node capacity type"
}