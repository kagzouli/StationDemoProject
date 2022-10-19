terraform {
  required_version = ">= 1.2.7"

  backend "s3" {
      region  = "eu-west-3" 
      encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.25.0"
    }

    tls = {
      version = "~> 2.2"
    }
  
  }
}

provider "aws" {
      region     = var.region
}


