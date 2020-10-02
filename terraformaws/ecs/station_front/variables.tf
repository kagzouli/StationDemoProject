variable "application"{ 
  type        =  string
  description = "Nom application"
}

variable "vpc_id" {
   type        = string
   description = "Identifiant du VPC"
}


variable "public_subnet1_id" {
   type        = string
   description = "Public subnet 1 id"
}

variable "public_subnet2_id" {
   type        = string
   description = "Public subnet 2 id"
}
