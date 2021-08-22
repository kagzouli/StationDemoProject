data "aws_iam_policy_document" "eks_efs_webidentity_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.shared_namespace}:station-efs-csi-controller-sa"]
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


resource "aws_iam_role" "eks_efs_iam_role" {
  name               = "station-efs-iam-role"
  assume_role_policy = data.aws_iam_policy_document.eks_efs_webidentity_role_policy.json
  tags = {
    Name        = "station-efs-iam-role"
    Environment = var.application
  }

}


resource "aws_iam_policy" "eks_efs_iam_policy" {
  name = "station-efs-iam-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint",
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
POLICY

}


resource "aws_iam_role_policy_attachment" "eks_efs_iam_policy_attachment" {
  role      = aws_iam_role.eks_efs_iam_role.name
  policy_arn = aws_iam_policy.eks_efs_iam_policy.arn

}
