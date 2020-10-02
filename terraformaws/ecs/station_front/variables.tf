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