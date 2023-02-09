data "aws_iam_policy_document" "kubvaultonprem_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kubvaultonprem_agent" {
  name               = "kubvaultonprem-agent"
  assume_role_policy = data.aws_iam_policy_document.kubvaultonprem_agent.json
}


resource "aws_iam_role_policy_attachment" "kubvaultonprem_agent" {
  role       = aws_iam_role.kubvaultonprem_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "kubvaultonprem_cloudwatch_policy" {
  role       =  aws_iam_role.kubvaultonprem_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "kubvaultonprem_ssmmanagedinstance_policy" {
  role       = aws_iam_role.kubvaultonprem_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "kubvaultonprem_agent" {
  name = "kubvaultonprem-agent"
  role = aws_iam_role.kubvaultonprem_agent.name
}
