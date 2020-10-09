variable "application"{ 
  type        =  string
  description = "Nom application"
}

variable "vpc_id" {
   type        = string
   description = "Identifiant du VPC"
}

# All the public subnets
variable "public_subnets_id" {
   type    = list(string)
   description = "List of subnets id"
}

# All the private subnets
variable "private_subnets_id" {
   type    = list(string)
   description = "List of subnets id"
}

variable "station_domainname" {
    type        =  string
    description = "Domaine name"
}

variable "availability_zones" {
   type        = string
   description = "Zone de disponibilites de l'application"
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


variable "station_front_container_port"{
   type        = number
   default     = 80
   description = "Port de station_back affiché à l'exterieur."
}

variable "station_front_count"{
   type        = number
   description = "Nombre de conteneurs station_front"
}


variable "region" {
  type        = string
  description = "Region"
}

variable "task_role_arn" {
  type        = string
  description = "ARN du role de la tache"
}

variable "execution_role_arn" {
  type        = string
  description = "execution_role_arn"
}

variable "station_front_url_external"{
  type        = string
  description = "URL du site web station"
}
