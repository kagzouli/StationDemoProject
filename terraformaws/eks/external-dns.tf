module "external_dns" {
  source               = "git::https://github.com/rhythmictech/terraform-aws-eks-iam-external-dns"
  cluster_name         = aws_eks_cluster.station_eks_cluster.name 
  issuer_url           = aws_eks_cluster.station_eks_cluster.identity[0].oidc[0].issuer
  kubernetes_namespace = "kube-system"
}

