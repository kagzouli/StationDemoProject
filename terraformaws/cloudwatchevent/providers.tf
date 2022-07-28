terraform {
  required_version = ">= 0.15.5"

  backend "s3" {
      region  = "eu-west-3" 
      encrypt = true
  }
}

provider "aws" {
      region     = var.region
}
