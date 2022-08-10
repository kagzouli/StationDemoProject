terraform {
  required_version = ">= 1.0.11"

  backend "s3" {
      region  = "eu-west-3" 
      encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.25.0"
    }
  
  }
}

provider "aws" {
      region     = var.region
}
