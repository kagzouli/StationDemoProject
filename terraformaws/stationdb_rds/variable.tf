variable "application"{ 
  type        =  string
  default     =  "stationdb"
  description = "Nom application"
}

variable "station_privatedomainname" {
    type        =  string
    description = "Private domaine name"
}

variable "station_db_host_port"{
   type        = number
   description = "Port de station_db affiché à l'exterieur."
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

#variable "task_role_arn" {
#  type        = string
#  description = "ARN du role de la tache"
#}

#variable "execution_role_arn" {
#  type        = string
#  description = "execution_role_arn"
#}

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


variable "station_db_count"{
  type        = number
  description = "Nombre d'instances de base."
}

variable "station_db_instance_type"{
  type        = string
  description = "Type d'instance DB"
}


#variable "aws_instanceprofile_ecsec2"{
#  type        = string
#  description = "AWS Instance profile ECS EC2"
#}
