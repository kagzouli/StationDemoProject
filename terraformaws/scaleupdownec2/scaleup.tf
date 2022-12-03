resource "aws_lambda_function" "scale_up" {
    filename                       = "lambda/scaleupdown.zip"
    function_name                  = "station-scale-up"
    role                           = aws_iam_role.scale_up.arn
    handler                        = "scaleupdown.scaleUpHandler"
    runtime                        = "python3.9"
    timeout                        = 60
    reserved_concurrent_executions = 1
    memory_size                    = 512
    architectures                  = [var.lambda_architecture]
    tags = {
      Name = "scale-upec2-lambda"
      Application= var.application
    }
}


resource "aws_lambda_permission" "scale_up" {
  statement_id  = "AllowScaleUpExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scale_up.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.scaleupdown_gateway.id}/*/${aws_api_gateway_method.scale_up.http_method}${aws_api_gateway_resource.scale_up.path}"

  depends_on = [
    aws_lambda_function.scale_up
  ]
}


resource "aws_cloudwatch_log_group" "scale_up" {
  name              = "/aws/lambda/${aws_lambda_function.scale_up.function_name}"
  retention_in_days = 1
  tags = {
      Name = "scale-upec2-cloudwatch"
      Application= var.application
    }
}

######################### Role Scale Up #################################################################
resource "aws_iam_role" "scale_up" {
  name                 = "station-action-scale-up-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags = {
      Name = "scale-upec2-role"
      Application= var.application
    }
}

resource "aws_iam_role_policy" "scale_up" {
  name = "station-lambda-scale-up-policy"
  role = aws_iam_role.scale_up.name
  policy = templatefile("${path.module}/policies/lambda-scale-up.json", {
    #arn_runner_instance_role  = aws_iam_role.runner.arn
    #sqs_arn                   = var.sqs_build_queue.arn
  })
}

resource "aws_iam_role_policy" "scale_up_logging" {
  name = "station-up-lambda-logging"
  role = aws_iam_role.scale_up.name
  policy = templatefile("${path.module}/policies/lambda-cloudwatch.json", {
    log_group_arn = aws_cloudwatch_log_group.scale_up.arn
  })
}

resource "aws_iam_role_policy_attachment" "scale_up_vpc_execution_role" {
  role       = aws_iam_role.scale_up.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
