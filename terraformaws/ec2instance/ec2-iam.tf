data "aws_iam_policy_document" "ecsec2_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsec2_agent" {
  name               = "ecsec2-agent"
  assume_role_policy = data.aws_iam_policy_document.ecsec2_agent.json
}


resource "aws_iam_role_policy_attachment" "ecsec2_agent" {
  role       = aws_iam_role.ecsec2_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "assume_role_cloudwatch_policy" {
  role       =  aws_iam_role.ecsec2_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "assume_role_ssmmanagedinstance_policy" {
  role       = aws_iam_role.ecsec2_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ecsec2_agent" {
  name = "ecsec2-agent"
  role = aws_iam_role.ecsec2_agent.name
}
