resource "aws_lambda_function" "scale_down" {
    filename                       = "lambda/scaleupdown.zip"
    function_name                  = "station-scale-down"
    role                           = aws_iam_role.scale_down.arn
    handler                        = "scaleupdown.scaleDownHandler"
    runtime                        = "python3.9"
    timeout                        = 60
    reserved_concurrent_executions = 1
    memory_size                    = 512
    architectures                  = [var.lambda_architecture]
    tags = {
      Name = "scale-downec2-lambda"
      Application= var.application
    }
}


resource "aws_cloudwatch_log_group" "scale_down" {
  name              = "/aws/lambda/${aws_lambda_function.scale_down.function_name}"
  retention_in_days = 1
  tags = {
      Name = "scale-downec2-cloudwatch"
      Application= var.application
    }
}

######################### Role Scale Down #################################################################
resource "aws_iam_role" "scale_down" {
  name                 = "station-action-scale-down-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags = {
      Name = "scale-downec2-role"
      Application= var.application
    }
}

resource "aws_iam_role_policy" "scale_down" {
  name = "station-lambda-scale-down-policy"
  role = aws_iam_role.scale_down.name
  policy = templatefile("${path.module}/policies/lambda-scale-down.json", {
    #arn_runner_instance_role  = aws_iam_role.runner.arn
    #sqs_arn                   = var.sqs_build_queue.arn
  })
}

resource "aws_iam_role_policy" "scale_down_logging" {
  name = "station-down-lambda-logging"
  role = aws_iam_role.scale_down.name
  policy = templatefile("${path.module}/policies/lambda-cloudwatch.json", {
    log_group_arn = aws_cloudwatch_log_group.scale_down.arn
  })
}

resource "aws_iam_role_policy_attachment" "scale_down_vpc_execution_role" {
  role       = aws_iam_role.scale_down.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
