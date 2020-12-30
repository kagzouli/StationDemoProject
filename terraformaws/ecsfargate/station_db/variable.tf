variable "application"{ 
  type        =  string
  description = "Nom application"
}

variable "vpc_id" {
   type        = string
   description = "Identifiant du VPC"
}

# All the private subnets
variable "private_subnets_id" {
   type    = list(string)
   description = "List of subnets id"
}

variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
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

variable "station_db_root" {
  type        = string
  description = "Database user root"
}

variable "station_db_databasename" {
  type        = string
  description = "Database name"
}

variable "station_db_username" {
  type        = string
  description = "Database username"
}

variable "station_db_password" {
  type        = string
  description = "Database password"
}

variable "station_db_url_external"{
  type        = string
  description = "URL de la base de donnee"
}

variable "cidr_block"{
  type        = string
  description = "CIDR block"
}