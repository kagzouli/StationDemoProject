resource "aws_security_group" "station_efs" {
  name        = "station-efs"
  description = "Controle les acces au partage EFS"
  vpc_id      = data.aws_vpc.station_vpc.id

  ingress {
    protocol    = "TCP"
    from_port   = 2049 
    to_port     = 2049
    cidr_blocks = [data.aws_vpc.station_vpc.cidr_block]
    description = "NFS Authorise"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "station-efs"
    Application= var.application
  }
}
