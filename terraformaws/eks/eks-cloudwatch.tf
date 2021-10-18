resource "aws_cloudwatch_log_group" "cloudwatch_log_group_stationredis" {
  name = "stationredis-eks-log-group"
  retention_in_days = 7

  tags = {
    Name        = "stationredis-eks-log-group"
    Environment = var.application
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_stationdb" {
  name = "stationdb-eks-log-group"
  retention_in_days = 7

  tags = {
    Name        = "stationdb-eks-log-group"
    Environment = var.application
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_stationback" {
  name = "stationback-eks-log-group"
  retention_in_days = 7

  tags = {
    Name        = "stationback-eks-log-group"
    Environment = var.application
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_stationfront" {
  name = "stationfront-eks-log-group"
  retention_in_days = 7

  tags = {
    Name        = "stationfront-eks-log-group"
    Environment = var.application
  }
}
