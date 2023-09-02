data "aws_iam_policy_document" "kubmastermanual_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
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


resource "aws_iam_role" "kubmastermanual_agent" {
  name               = "kubmastermanual-agent"
  assume_role_policy = data.aws_iam_policy_document.kubmastermanual_agent.json
}


resource "aws_iam_role_policy_attachment" "kubmanualmaster_agent" {
  role       = aws_iam_role.kubmastermanual_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "kubmanualmaster_cloudwatch_policy" {
  role       =  aws_iam_role.kubmastermanual_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "kubmanualmaster_ssmmanagedinstance_policy" {
  role       = aws_iam_role.kubmastermanual_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "autoscaler_iam_policy_attachment" {
  role      = aws_iam_role.kubmastermanual_agent.name
  policy_arn = aws_iam_policy.autoscaler_iam_policy.arn

}


resource "aws_iam_instance_profile" "kubmastermanual_agent" {
  name = "kubmastermanual-agent"
  role = aws_iam_role.kubmastermanual_agent.name
}

