resource "aws_eks_fargate_profile" "aws_eks_fargate" {
  cluster_name           = aws_eks_cluster.station_eks_cluster.name
  fargate_profile_name   = "aws-eks-profile-fargate"
  pod_execution_role_arn = aws_iam_role.aws_eks_fargate_role.arn
  subnet_ids             = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ] 

  selector {
    namespace = "station_namespace"
  }

  timeouts {
    create   = "30m"
    delete   = "30m"
  }
}
