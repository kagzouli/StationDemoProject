terraform {
  required_version = ">= 0.12.18"

  backend "s3" {
      region  = "eu-west-3" 
      bucket  = "station-tfstate"
      key     = "station-eksstationfront.tfstate"
      encrypt = true
  }
}

provider "aws" {
      region     = var.region
}



provider "kubernetes" {
  config_path = "~/.kube/config"
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}
