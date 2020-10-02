data "aws_iam_role" "station_front_execution_role" {
  name = "station_front_execution_role"
}

resource "aws_iam_role" "station_front_iam_role" {
  name = "${var.project}-role-${var.environment}"

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
    ApplicationCode = "${var.app_code}"
    Automation      = "${var.automation}"
    BU              = "${var.bu}"
    Creator         = "${var.iam_creator}"
    Criticity       = "${var.criticity}"
    DateTimeTag     = ""
    Environment     = "${var.environment}"
    Name            = "${var.project}-role-${var.environment}"
    Note            = ""
    Owner           = "${var.iam_owner}"
    Support         = "${var.support}"
  }
}