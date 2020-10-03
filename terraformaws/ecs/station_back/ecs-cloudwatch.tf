resource "aws_cloudwatch_log_group" "station_back_cloudwatch_log" {
  name = "station_back_cloudwatch_log"

  tags = {
    Name = "station_back_cloudwatch_log"
    Application= var.application
  }
}
