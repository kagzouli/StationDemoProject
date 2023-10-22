resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/station-eks-cluster/cluster"
  retention_in_days = 30

  tags = {
    Name        = "station-eks-cloudwatch-log-group"
    Application = var.application
  }
}



resource "aws_eks_cluster" "station_eks_cluster" {
  name     = "station-eks-cluster"
  role_arn = aws_iam_role.aws_eks_iam_role.arn
  version  = "1.27"
  
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

# Aws launch template
resource "aws_launch_template" "station_eks_launch_template" {
  name_prefix =  "station-eks-launch-template"

  vpc_security_group_ids = [aws_eks_cluster.station_eks_cluster.vpc_config[0].cluster_security_group_id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size =  20 
      volume_type = "gp2"
    }
  }

  instance_type = "t3.large" 
  

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "station-eks-launch-template"
      Application= var.application
    }
  }
}




resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.station_eks_cluster.name
  node_group_name = "station"
  node_role_arn   = aws_iam_role.aws_eks_nodes_role.arn
  subnet_ids      = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id  ]
  capacity_type   = var.node_capacity_type

  launch_template {
      name = aws_launch_template.station_eks_launch_template.name
      version = aws_launch_template.station_eks_launch_template.latest_version
  }

  # We start with a minimal setup
  scaling_config {
    min_size     = var.nbNodeInstanceEks 
    desired_size = var.nbNodeInstanceEks 
    max_size     = 4
   
  }

  



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
      "k8s.io/cluster/${aws_eks_cluster.station_eks_cluster.name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled" = "true"
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.station_eks_cluster.name}" = "owned"

  }
}

/*resource "aws_autoscaling_group" "station_eks_autoscaling_group" {
    name                      = "eks-station-autoscaling"
    vpc_zone_identifier       = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id  ]
    launch_template {
      name = aws_launch_template.station_eks_launch_template.name
      version = aws_launch_template.station_eks_launch_template.latest_version
    }

    min_size                  = var.nbNodeInstanceEks 
    desired_capacity          = var.nbNodeInstanceEks 
    max_size                  = 4

    tag {
      key                 = "name"
      value               = "eks-station-autoscaling"
      propagate_at_launch = true
    }

    tag {
      key                 = "k8s.io/cluster/${aws_eks_cluster.station_eks_cluster.name}"
      value               = "owned"
      propagate_at_launch = true
    }

    tag {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "true"
      propagate_at_launch = true
    }

    tag {
      key                 = "k8s.io/cluster-autoscaler/${aws_eks_cluster.station_eks_cluster.name}"
      value               = "owned"
      propagate_at_launch = true
    }

    tag {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/${var.instance_group_prefix}"
      value               = var.instance_group_prefix
      propagate_at_launch = true
    }

     tag {
      key                 = "Application"
      value               = var.application
      propagate_at_launch = true
    }

}*/


data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.station_eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.station_eks_cluster.identity[0].oidc[0].issuer
}

