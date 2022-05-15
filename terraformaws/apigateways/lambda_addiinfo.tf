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


