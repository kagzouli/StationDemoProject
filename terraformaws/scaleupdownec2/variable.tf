variable "region" {
  type        = string
  description = "Region of the VPC"
}


variable "lambda_runtime" {
  description = "AWS Lambda runtime."
  type        = string
  default     = "nodejs16.x"
}


variable "lambda_architecture" {
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["arm64", "x86_64"], var.lambda_architecture)
    error_message = "`lambda_architecture` value is not valid, valid values are: `arm64` and `x86_64`."
  }
}


variable "application"{ 
  type        =  string
  description = "Application"
  default     = "STATION"
}
