############### EKS nodes ##################################

resource "aws_iam_role" "aws_eks_nodes_role" {
  name_prefix = "aws-eks-nodes-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
      Name = "aws-eks-nodes-role"
      Application= var.application
  }

}

resource "aws_iam_role_policy_attachment" "nodes_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.aws_eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.aws_eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.aws_eks_nodes_role.name
}



################# EKS cluster #################################


resource "aws_iam_role" "aws_eks_iam_role" {
  # Using a prefix ensures a unique name
  name_prefix = "aws-eks-iam-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
      Name = "aws-eks-iam-role"
      Application= var.application
  }

}

# We also need to attach additional policies:
resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.aws_eks_iam_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: 
resource "aws_iam_role_policy_attachment" "cluster_eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.aws_eks_iam_role.name
}
