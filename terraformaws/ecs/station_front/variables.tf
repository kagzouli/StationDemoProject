variable "application"{ 
  type        =  string
  description = "Nom application"
}

variable "vpc_id" {
   type        = string
   description = "Identifiant du VPC"
}

# All the public subnets
variable "public_subnets" {
   description = "public subnets"
}

variable "station_front_container_memory"{
   type        = string
   description = "station Front container memory"
}

variable "station_front_container_cpu"{
   type        = string
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


variable "region" {
  type        = string
}



