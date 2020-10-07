resource "aws_cloudwatch_log_group" "station_back_cloudwatch_log" {
  name = "station-back-cloudwatch-log"

  tags = {
    Name = "station-back-cloudwatch-log"
    Application= var.application
  }
}
