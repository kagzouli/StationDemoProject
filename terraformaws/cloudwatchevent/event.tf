resource "aws_cloudwatch_event_rule" "lambda_monitoring" {   
  name                = "station-lambda-monitoring-cloudwatch"
  description         = "trig lambda for monitoring (every 2 min)"
  schedule_expression = "rate(2 minutes)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "lambda_monitoring" {   
  rule      = aws_cloudwatch_event_rule.lambda_monitoring.name
  target_id = "lambda_monitoring"
  arn       =  aws_lambda_function.monitoring.arn
} 

##########################################################
########### PERMISSIONS                          #########
##########################################################


# policy for the lambda monitoring to be scheduled
resource "aws_lambda_permission" "lambda_monitoring_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.monitoring.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_monitoring.arn
}


