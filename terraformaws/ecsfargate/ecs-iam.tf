resource "aws_iam_role" "station_iam_role" {
  name = "station_iam_role"

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
   Name = "station_iam_role"
   Application= var.application
  }
}

resource "aws_iam_policy" "station_iam_role_policy" {
  name        = "station_iam_role_policy"
  description = "Policy for reading data"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
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
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_station_iam_role" {
  role       = aws_iam_role.station_iam_role.name
  policy_arn = aws_iam_policy.station_iam_role_policy.arn
}

# Execution Role
resource "aws_iam_policy" "station_execution_role_policy" {
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

resource "aws_iam_role" "station_execution_role" {
  name = "station_execution_role"
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
  role      = aws_iam_role.station_execution_role.name
  policy_arn = aws_iam_policy.station_execution_role_policy.arn
}