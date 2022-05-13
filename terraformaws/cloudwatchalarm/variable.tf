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



variable "station_back_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
}

variable "station_front_instance_count"{
   type        = number
   description = "Nombre de conteneurs station_back"
}

variable "mail_cloudwatch_alert"{
  type        = list
  description = "List des mails."
}
