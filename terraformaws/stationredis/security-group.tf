# ALB Security Group: Edit to restrict access to the redis 
resource "aws_security_group" "secgroup_station_redis" {
  name        = "securitygroup-station-redis"
  description = "Controle les acces a Redis"
  vpc_id      =  data.aws_vpc.station_vpc.id 

  ingress {
    protocol    = "tcp"
    from_port   = var.station_redis_host_port
    to_port     = var.station_redis_host_port
    cidr_blocks = ["${data.aws_vpc.station_vpc.cidr_block}"]
    description = "TCP request"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitygroup-station-redis"
    Application= var.application
  }
}

