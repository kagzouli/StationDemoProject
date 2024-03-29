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
   description = "List of public subnets id"
}

# All the private subnets
variable "private_subnets_id" {
   type    = list(string)
   description = "List of private subnets id"
}

variable "station_publicdomainname" {
    type        =  string
    description = "Public Domaine name"
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

variable "station_back_container_port"{
   type        = number
   default     = 8080
   description = "Port de station_back affiché à l'exterieur."
}

variable "station_back_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
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

variable "station_back_url_external"{
  type        = string
  description = "URL du backend accessible"
}

variable "context_db"{
  type        = string
  description = "Context of the database"
}

variable "station_db_username"{
  type        = string
  description = "Database username"
}

variable "aws_instanceprofile_ecsec2"{
  type        = string
  description = "AWS Instance profile ECS EC2"
}

variable "station_redis_hostname"{
  type        = string
  description = "Redis hostname"
}

variable "station_redis_port"{
  type        = string
  description = "Redis port"
}

