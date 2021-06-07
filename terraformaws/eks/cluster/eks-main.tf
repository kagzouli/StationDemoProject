resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/station-eks-cluster/cluster"
  retention_in_days = 30

  tags = {
    Name        = "station-eks-cloudwatch-log-group"
    Environment = var.application
  }
}



resource "aws_eks_cluster" "station_eks_cluster" {
  name     = "station-eks-cluster"
  role_arn = aws_iam_role.aws_eks_iam_role.arn
  version  = "1.18"

  vpc_config {
    subnet_ids = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_eks_cluster_policy,
    aws_iam_role_policy_attachment.cluster_eks_vpc_resource_controller,
    aws_cloudwatch_log_group.eks_cluster
  ]

  tags = {
      Name = "station_eks_cluster"
      Application= var.application
  }
}


resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.station_eks_cluster.name
  node_group_name = "default"
  node_role_arn   = aws_iam_role.aws_eks_nodes_role.arn
  subnet_ids      = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id  ]

  # We start with a minimal setup
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2 
  }

  # I'd recommend t3.large or t3.xlarge for most production workloads
  instance_types = ["t2.micro"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodes_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_ec2_container_registry_read_only,
  ]

  tags = {
      Name = "station_eks_nodes"
      Application= var.application
  }
}
