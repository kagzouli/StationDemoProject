resource "aws_cloudwatch_log_group" "station_front_cloudwatch_log" {
  name = "station_front_cloudwatch_log"

  tags = {
    Name = "station_front_cloudwatch_log"
    Application= var.application
  }
}
