resource "aws_secretsmanager_secret_policy" "station_sm_policy" {
  secret_arn = aws_secretsmanager_secret.station_secretmanager.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
                    "eks.amazonaws.com",
                    "ecs.amazonaws.com",
                    "lambda.amazonaws.com"]
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}
