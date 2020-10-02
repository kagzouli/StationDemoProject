
resource "aws_secretsmanager_secret" "station_secret_manager" {
  name = "station_secret_manager"

  tags = {
    Name = "station_secret_manager"
    Application= var.application
  }
}

resource "aws_secretsmanager_secret_version" "station_secret_version" {
  secret_id     = "${aws_secretsmanager_secret.station_secret_manager.id}"
  secret_string = "${jsonencode(local.docker_registry_identification)}"
}

