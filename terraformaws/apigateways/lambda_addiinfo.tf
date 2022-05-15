resource "aws_lambda_function" "addiinfo_get" {
  filename         = "addiinfo.zip"
  function_name    = "station-lambda-addiinfo"
  handler          = "addiinfo.get"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "python3.9"
  source_code_hash = data.archive_file.addiinfo.output_base64sha256
  publish          = true

}


data "archive_file" "addiinfo" {
  type        = "zip"
  source_file = "lambda/addiinfo_function.py"
  output_path = "addiinfo.zip"
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

tags = {
      Name = "lambda-iam-role"
      Application= var.application
  }

 
}

resource "aws_iam_role_policy_attachment" "lambda_attachment_standard" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

