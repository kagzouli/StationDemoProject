resource "aws_cloudwatch_log_group" "station_front_cloudwatch_log" {
  name = "station-front-cloudwatch-log"

  tags = {
    Name = "station-front-cloudwatch-log"
    Application= var.application
  }
}
