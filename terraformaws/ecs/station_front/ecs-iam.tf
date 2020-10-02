resource "aws_iam_role" "station_front_iam_role" {
  name = "station_front_iam_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": [
                "ecs-tasks.amazonaws.com"
            ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = {
   Name = "station_front_iam_role"
   Application= var.application
  }
}

resource "aws_iam_role" "station_front_execution_role" {
  name               = "station_front_execution_role"
  assume_role_policy = data.aws_iam_policy_document.station_front_execution_role_policy.json
  tags = {
        Name = "station_front_execution_role"
        Application= var.application
  }
}

data "aws_iam_policy_document" "station_front_execution_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Execution Role

resource "aws_iam_policy" "station_front_execution_role_policy" {
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "",
          "Effect": "Allow",
          "Action": [
              "kms:List*",
              "kms:Describe*",
              "kms:Decrypt"
          ],
          "Resource": "*"
      },
      {
          "Sid": "",
          "Effect": "Allow",
          "Action": [
              "secretsmanager:ListSecrets",
              "secretsmanager:ListSecretVersionIds",
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret"
          ],
          "Resource": "*"
      },
      {
          "Sid": "",
          "Effect": "Allow",
          "Action": "logs:*",
          "Resource": "*"
      }
  ]
}
POLICY
}

resource "aws_iam_role" "station_front_execution_role" {
  name = "${var.project}-iam-task-execution-role-${var.environment}"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution_attachment" {
  role      = aws_iam_role.station_front_execution_role.name
  policy_arn = aws_iam_policy.station_front_execution_role_policy.arn
}