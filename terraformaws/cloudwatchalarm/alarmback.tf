#############################################################################
########### ALARM FOR back PART                                        #####
#############################################################################

resource "aws_cloudwatch_metric_alarm" "station_back_healthy" {
  alarm_name          = "station-back-healthy"
  alarm_description   = "Une ou plusieurs des ${var.station_back_instance_count} instance back n'est plus opérationnelle"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.station_back_instance_count

  dimensions = {
    LoadBalancer = data.aws_alb.station_back_alb.arn_suffix
    TargetGroup  = data.aws_alb_target_group.station_back_target_group.arn_suffix
  }

  alarm_actions      = [aws_sns_topic.station_cloudwatch_events_sns_alerting.arn]
  treat_missing_data = "notBreaching"

  tags = {
      Name = "station-back-healthy"
      Application= var.application
  }

}

