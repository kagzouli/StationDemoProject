resource "aws_efs_file_system" "station_efs" {

   creation_token = "station-efs"

   encrypted       = true

  tags = {
      Name        = "station-efs"
      Environment = var.application
  }

}



resource "aws_efs_mount_target" "station_efs_mount" {

  count           = 2

  file_system_id  = aws_efs_file_system.station_efs.id

  subnet_id       =  element( [data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ], count.index) 

}

resource "aws_efs_access_point" "station_efs_accesspoint" {
  file_system_id = aws_efs_file_system.station_efs.id
  root_directory {
    path = "/"
    
  }
  posix_user {
    uid = 65534
    gid = 65534

  }

   tags = {
    Name        = "station-efs-accesspoint"
    Environment = var.application
  }

}

