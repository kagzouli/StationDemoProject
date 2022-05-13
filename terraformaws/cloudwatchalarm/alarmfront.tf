#############################################################################
########### ALARM FOR front PART                                        #####
#############################################################################

resource "aws_cloudwatch_metric_alarm" "station_front_healthy" {
  alarm_name          = "station-front-healthy"
  alarm_description   = "Une ou plusieurs des ${var.station_front_instance_count} instance front n'est plus opérationnelle"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.station_front_instance_count

  dimensions = {
    LoadBalancer = data.aws_alb.station_front_alb.arn_suffix
    TargetGroup  = data.aws_alb_target_group.station_front_target_group.arn_suffix
  }

  alarm_actions      = [aws_sns_topic.station_cloudwatch_events_sns_alerting.arn]
  treat_missing_data = "notBreaching"

  tags = {
      Name = "station-front-healthy"
      Application= var.application
  }

}

