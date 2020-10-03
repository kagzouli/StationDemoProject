resource "aws_cloudwatch_log_group" "station_db_cloudwatch_log" {
  name = "station_db_cloudwatch_log"

  tags = {
    Name = "station_db_cloudwatch_log"
    Application= var.application
  }
}
