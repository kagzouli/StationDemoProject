#ws_lambda_function##############################################################
############ adddinfo : Get method                           ##
###############################################################
resource "aws_lambda_function" "addiinfo_get" {
  filename         = "addiinfo.zip"
  function_name    = "station-lambda-addiinfo"
  handler          = "addiinfo.get_handler"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "python3.9"
  source_code_hash = data.archive_file.addiinfo.output_base64sha256
  publish          = true

}

resource "aws_lambda_permission" "lambda_addiinfo_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.addiinfo_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.addiinfo_get.http_method}${aws_api_gateway_resource.addiinfo.path}"

  depends_on = [
    aws_lambda_function.addiinfo_get,
  ]
}


data "archive_file" "addiinfo" {
  type        = "zip"
  source_file = "addiinfo.py"
  output_path = "addiinfo.zip"
}


