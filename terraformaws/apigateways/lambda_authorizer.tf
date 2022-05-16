##############################################################
############ adddinfo : Get method                           ##
###############################################################
resource "aws_lambda_function" "lambda_authorizer" {
  filename         = "authorizer.zip"
  function_name    = "station-lambda-authorizer"
  handler          = "authorizer.authorize"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "python3.9"
  source_code_hash = data.archive_file.authorizer.output_base64sha256
  publish          = true

}


resource "aws_lambda_permission" "okta_lambda_permission" {
  statement_id  = "AllowOktaLambdaPermission"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*/*"

  depends_on = [
    aws_lambda_function.lambda_authorizer
  ]

}


data "archive_file" "authorizer" {
  type        = "zip"
  source_file = "authorizer.py"
  output_path = "authorizer.zip"
}

