data "aws_iam_policy_document" "eks_secret_webidentity_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.shared_namespace}:station-external-secret-sa"]
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



resource "aws_iam_role" "eks_secret_iam_role" {
  name               = "station-secret-iam-role"
  assume_role_policy = data.aws_iam_policy_document.eks_secret_webidentity_role_policy.json
  tags = {
    Name        = "station-efs-iam-role"
    Environment = var.application
  }

}

resource "aws_iam_policy" "eks_secret_iam_policy" {
  name = "station-secret-iam-policy"
  policy = <<POLICY
{ 
    "Version": "2012-10-17", 
    "Statement": [
     { 
        "Effect": "Allow", 
        "Action": [ 
            "secretsmanager:GetSecretValue", 
            "kms:Decrypt"
        ], 
        "Resource": "*"
    } 
    ] 
}
POLICY

}


resource "aws_iam_role_policy_attachment" "eks_secret_iam_policy_attachment" {
  role      = aws_iam_role.eks_secret_iam_role.name
  policy_arn = aws_iam_policy.eks_secret_iam_policy.arn

}

