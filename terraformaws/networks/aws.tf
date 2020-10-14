terraform {
  required_version = ">= 0.12.18"

  backend "s3" {
      region  = var.region
      bucket  = "station-tfstate"
      key     = "station-network.tfstate"
      encrypt = true
  }
}

provider "aws" {
      region     = var.region
}
