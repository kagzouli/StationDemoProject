// Secret manager for RDS
data "aws_secretsmanager_secret" "station_secretmanager" {
  name = "stationsec-secretmanager"
}

