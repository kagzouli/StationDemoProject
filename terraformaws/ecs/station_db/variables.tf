variable "application"{ 
  type        =  string
  description = "Nom application"
}

variable "vpc_id" {
   type        = string
   description = "Identifiant du VPC"
}

# All the public subnets
variable "subnets_id" {
   type    = list(string)
   description = "List of subnets id"
}

variable "station_db_container_memory"{
   type        = number
   description = "station Db container memory"
}

variable "station_db_container_cpu"{
   type        = number
   description = "station db container cpu"
}

variable "station_db_image"{
   type        = string
   description = "Image docker du station_db"
}

variable "station_db_host_port"{
   type        = number
   description = "Port de station_db affiché à l'exterieur."
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


