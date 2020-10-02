resource "aws_iam_role" "station_front_iam_role" {
  name = "station_front_execution_role"

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
   Name = "station_front_execution_role"
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