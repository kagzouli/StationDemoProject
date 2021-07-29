resource "aws_elasticache_subnet_group" "station_redis_subnet_group" {
  name       = "station-redis-subnets-group"
  subnet_ids = [ data.aws_subnet.station_privatesubnet1.id, data.aws_subnet.station_privatesubnet2.id]

}


resource "aws_elasticache_replication_group" "station_redis_cluster" {
  replication_group_id           =  "station-redis-cluster"
  engine                         =  "redis"
  replication_group_description  =  "Redis cluster for caching storage (has automatic eviction)"
  node_type                      =  var.station_redis_instance_type 
  transit_encryption_enabled     =  true
  at_rest_encryption_enabled     =  true
  auth_token                     =  jsondecode(data.aws_secretsmanager_secret_version.station_vers_secretmanager.secret_string)["stationredispassword"] 
  number_cache_clusters          =  var.station_redis_count
  automatic_failover_enabled     =  false
  availability_zones             =  ["${var.az_zone1}", "${var.az_zone2}"] 
  security_group_ids             =  [aws_security_group.secgroup_station_redis.id] 
  subnet_group_name              =  aws_elasticache_subnet_group.station_redis_subnet_group.name
  parameter_group_name           =  "default.redis6.x"
  port                           =  var.station_redis_host_port

  tags = {
     Name = "station-redis-cluster"
     Application= var.application
  }


}
