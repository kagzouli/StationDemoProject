######################################################
#
# RDS  Cluster Definition
#####################################################

resource "aws_db_subnet_group" "station_db_rds_subnet_group" {
  name        = "station-db-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = [ data.aws_subnet.station_privatesubnet1.id, data.aws_subnet.station_privatesubnet2.id] 
  tags = {
     Name = "station-db-rds-subnet-group"
     Application= var.application
  }

}

resource "aws_rds_cluster" "station_db_rds_cluster" {
  cluster_identifier      = "station-db-rds-cluster"
  availability_zones      = ["${var.az_zone1}", "${var.az_zone2}"] 
  engine                  = "aurora-mysql" 
  engine_version          = "5.7.mysql_aurora.2.03.2" 
  database_name           = var.station_db_databasename
  master_username         = var.station_db_username
  master_password         = var.station_db_password
  storage_encrypted       = true
  db_subnet_group_name    = aws_db_subnet_group.station_db_rds_subnet_group.name
  preferred_backup_window = "07:00-09:00"
  backup_retention_period = 5 
  vpc_security_group_ids = [aws_security_group.sg_station_db_ecs.id]

  skip_final_snapshot    =  true

  tags = {
     Name = "station-db-ecs-cluster"
     Application= var.application
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }


}


resource "aws_rds_cluster_instance" "rds_instance" {

  identifier                 = "station-db-instance-${count.index}" 
  count 		     = var.station_db_count
  cluster_identifier         = aws_rds_cluster.station_db_rds_cluster.id
  engine                     = aws_rds_cluster.station_db_rds_cluster.engine 
  engine_version             = aws_rds_cluster.station_db_rds_cluster.engine_version 
  instance_class             = var.station_db_instance_type
  publicly_accessible        = false
  db_subnet_group_name       = aws_db_subnet_group.station_db_rds_subnet_group.id
  auto_minor_version_upgrade = true
  apply_immediately          = true 
  
  tags = {
     Name = "station-db-ecs-cluster-instance"
     Application= var.application
  }

  lifecycle {
    create_before_destroy = true
  }

 
}

output "db_cluster_url"{
  value = ["${aws_rds_cluster.station_db_rds_cluster.endpoint}"]
}
