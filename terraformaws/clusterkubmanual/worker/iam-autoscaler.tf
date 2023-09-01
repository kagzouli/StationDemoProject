

resource "aws_iam_role" "autoscaler_iam_role" {
  name               = "station-cluster-autoscaler-iam-role"
  assume_role_policy = data.aws_iam_policy_document.eks_autoscaler_webidentity_role_policy.json
  tags = {
    Name        = "station-cluster-autoscaler-iam-role"
    Environment = var.application
  }

}


resource "aws_iam_policy" "autoscaler_iam_policy" {
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
        "ec2:DescribeLaunchTemplateVersions",
        "autoscaling:DescribeTags"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeInstanceTypes"
      ],
      "Resource": ["*"]
    }
  ]
}
POLICY

}


resource "aws_iam_role_policy_attachment" "autoscaler_iam_policy_attachment" {
  role      = aws_iam_role.autoscaler_iam_role.name
  policy_arn = aws_iam_policy.autoscaler_iam_policy.arn

}
