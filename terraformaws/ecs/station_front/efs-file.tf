resource "aws_efs_file_system" "station_front_efs" {
  tags = {
    Name = "station-front-ecs",
    Application= var.application
  }
}

resource "aws_efs_mount_target" "station_front_efs_mount" {
  file_system_id = aws_efs_file_system.station_front_efs.id
  subnet_id      = var.public_subnets_id[0]

}
