##############################################################
############ adddinfo : Get method                           ##
###############################################################
resource "aws_lambda_function" "addiinfo_get" {
  filename         = "addiinfo.zip"
  function_name    = "station-lambda-addiinfo-get"
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


##############################################################
############ adddinfo : delete method                       ##
###############################################################
resource "aws_lambda_function" "addiinfo_delete" {
  filename         = "addiinfo.zip"
  function_name    = "station-lambda-addiinfo-delete"
  handler          = "addiinfo.delete_handler"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "python3.9"
  source_code_hash = data.archive_file.addiinfo.output_base64sha256
  publish          = true

}

resource "aws_lambda_permission" "lambda_addiinfo_delete" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.addiinfo_delete.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.addiinfo_delete.http_method}${aws_api_gateway_resource.addiinfo.path}"

  depends_on = [
    aws_lambda_function.addiinfo_get,
  ]
}


##############################################################
############ adddinfo : put method                           ##
###############################################################
resource "aws_lambda_function" "addiinfo_put" {
  filename         = "addiinfo.zip"
  function_name    = "station-lambda-addiinfo-put"
  handler          = "addiinfo.put_handler"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "python3.9"
  source_code_hash = data.archive_file.addiinfo.output_base64sha256
  publish          = true

}

resource "aws_lambda_permission" "lambda_addiinfo_put" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.addiinfo_put.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.addiinfo_put.http_method}${aws_api_gateway_resource.addiinfo.path}"

  depends_on = [
    aws_lambda_function.addiinfo_get,
  ]
}




data "archive_file" "addiinfo" {
  type        = "zip"
  source_file = "addiinfo.py"
  output_path = "addiinfo.zip"
}


