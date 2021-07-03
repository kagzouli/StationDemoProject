# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
  vars = {
    # ecs_cluster_name  = aws_ecs_cluster.station_back_ecs_cluster.name
  }
}




resource "aws_instance" "instance" {
  ami           = data.aws_ami.ecs_optimized.id
  instance_type = "t3.micro"

  user_data     = data.template_file.user_data.rendered 

  subnet_id     = data.aws_subnet.station_privatesubnet1.id

  security_groups = [ aws_security_group.station_ec2_sg.id ]

  iam_instance_profile = aws_iam_instance_profile.ecsec2_agent.name

  tags = {
    Name = "instanceconnexion"
    Application= var.application
  }
}
