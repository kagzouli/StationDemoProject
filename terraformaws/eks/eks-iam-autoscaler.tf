


data "aws_iam_policy_document" "eks_autoscaler_webidentity_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.shared_namespace}:cluster-autoscaler-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_openid.arn]
      type        = "Federated"
    }
  }

  depends_on = [
    aws_iam_openid_connect_provider.eks_openid
  ]
}


resource "aws_iam_role" "eks_autoscaler_iam_role" {
  name               = "station-cluster-autoscaler-iam-role"
  assume_role_policy = data.aws_iam_policy_document.eks_autoscaler_webidentity_role_policy.json
  tags = {
    Name        = "station-cluster-autoscaler-iam-role"
    Environment = var.application
  }

}


resource "aws_iam_policy" "eks_autoscaler_iam_policy" {
  name = "autoscaler-iam-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeInstanceTypes",
        "eks:DescribeNodegroup"
      ],
      "Resource": ["*"]
    }
  ]
}
POLICY

}


resource "aws_iam_role_policy_attachment" "eks_autoscaler_iam_policy_attachment" {
  role      = aws_iam_role.eks_autoscaler_iam_role.name
  policy_arn = aws_iam_policy.eks_autoscaler_iam_policy.arn

}
