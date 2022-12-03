# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}