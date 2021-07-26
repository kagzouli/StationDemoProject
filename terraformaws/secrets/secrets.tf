resource "aws_secretsmanager_secret" "station_secretmanager" {
  name = "stationsec-secretmanager"
  kms_key_id = aws_kms_key.station_kms_key.id

  recovery_window_in_days = 0 

  depends_on = [aws_kms_key.station_kms_key]
  
  tags = {
    Name = "stationsec-secretmanager",
    Application= var.application
  }

}

resource "aws_secretsmanager_secret_version" "station_version_secretmanager" {
  secret_id = aws_secretsmanager_secret.station_secretmanager.id
  secret_string = jsonencode(local.station_credentials)

  depends_on = [aws_secretsmanager_secret.station_secretmanager]
       
}
