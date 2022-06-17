variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "application"{
  type        =  string
  description = "Application"
  default     = "STATION"
}


# Runtime monitoring exec
variable "lambda_runtime_monitoring" {
  default = "python3.9"
}

# Timeout monitoring 
variable "lambda_timeout_monitoring" {
  default = "45" # Seconds
}

# Memory monitoring
variable "lambda_memory_size_monitoring" {
  default = "128" # MB
}

