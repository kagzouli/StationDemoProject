##############################################################
############ adddinfo : Get method                           ##
###############################################################
resource "aws_lambda_function" "lambda_authorizer" {
  filename         = "api_lambda_authorizer.zip"
  function_name    = "station-lambda-authorizer"
  handler          = "lambda_authorizer.handler"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "nodejs14.x"
  source_code_hash = data.archive_file.authorizer.output_base64sha256

}


resource "aws_lambda_permission" "station_authorizer_lambda_permission" {
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
  source_dir  = "lambda_authorizer/"
  output_path = "api_lambda_authorizer.zip"
}

