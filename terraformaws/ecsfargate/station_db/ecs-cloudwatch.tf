resource "aws_cloudwatch_log_group" "station_db_cloudwatch_log" {
  name = "station-db-cloudwatch-log"

  tags = {
    Name = "station-db-cloudwatch-log"
    Application= var.application
  }
}
