terraform {
  required_version = ">= 0.15.5"

  backend "s3" {
      region  = "eu-west-3" 
      bucket  = "station-tfstate"
      key     = "station-redis.tfstate"
      encrypt = true
  }
}

provider "aws" {
      region     = var.region
}
