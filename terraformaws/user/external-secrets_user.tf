############### User devops-user ###########################################
resource "aws_iam_user" "external_secrets_user" {
  name = "external-secrets"

  # Comme on est en test , on met true
  force_destroy  = true

  tags = {
     Name = "external-secrets"
     Application= var.application
  }
}


resource "aws_iam_user_policy" "external_secrets_user_policy" {
  name = "external-secrets-policy"
  user = aws_iam_user.external_secrets_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Action": [
                "secretsmanager:GetSecretValue",
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
   ]
}
EOF
}
