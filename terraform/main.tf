provider "aws" {
      region     = "var.region"
}

resource "aws_vpc" "station_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}