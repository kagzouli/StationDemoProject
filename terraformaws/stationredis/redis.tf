resource "aws_elasticache_cluster" "station_redis_cluster" {
  cluster_id           =  "station-redis-cluster"
  engine               =  "redis"
  node_type            =  var.station_redis_instance_type 
  num_cache_nodes      =  var.station_redis_count
  security_group_ids   =  [ data.aws_subnet.station_privatesubnet1.id, data.aws_subnet.station_privatesubnet2.id] 
  parameter_group_name =  "default.redis3.2"
  engine_version       =  "3.2.10"
  port                 =  var.station_redis_host_port

  tags = {
     Name = "station-redis-cluster"
     Application= var.application
  }


}
