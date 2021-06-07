resource "kubernetes_namespace" "fargate_namespace" {
  metadata {
    labels = {
      app = "stationfront"
    }
    name = "stationfront-deploy"
  }
}



resource "aws_eks_fargate_profile" "aws_eks_fargatefront" {
  cluster_name           = data.aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "aws-eks-profile-fargatefront"
  pod_execution_role_arn = aws_iam_role.aws_eks_fargatefront_role.arn
  subnet_ids             = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ] 

  selector {
    namespace = "default"
  }

  selector {
    namespace = "stationfront-deploy" 
  }

  timeouts {
    create   = "30m"
    delete   = "30m"
  }
}
