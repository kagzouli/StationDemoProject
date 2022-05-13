terraform {
  required_version = ">= 0.12.18"

  backend "s3" {
      region  = "eu-west-3" 
      bucket  = "station-tfstate"
      key     = "station-cloudwatchalarm.tfstate"
      encrypt = true
  }
}

provider "aws" {
      region     = var.region
}
