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

resource "random_password" "station_db_root_password" {
  length           = 16
  special          = true
  override_special = "_%="
}

resource "random_password" "station_db_password" {
  length           = 16
  special          = true
  override_special = "_%="
}

resource "random_password" "station_redis_password" {
  length           = 16
  special          = true
  override_special = "_%="
}

locals {
  station_credentials = {
    stationdbrootpassword  = random_password.station_db_root_password.result 
    stationdbpassword      = random_password.station_db_password.result
    stationredispassword   = random_password.station_redis_password.result
  }
}


resource "aws_secretsmanager_secret_version" "station_version_secretmanager" {
  secret_id = aws_secretsmanager_secret.station_secretmanager.id
  secret_string = jsonencode(local.station_credentials)

  depends_on = [aws_secretsmanager_secret.station_secretmanager]
       
}
