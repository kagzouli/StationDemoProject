# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
}




resource "aws_instance" "kubernatemaster" {
  ami           = data.aws_ami.ecs_optimized.id
  instance_type = "t3.micro"

  user_data     = data.template_file.user_data.rendered 

  subnet_id     = data.aws_subnet.station_privatesubnet1.id

  security_groups = [ aws_security_group.kubmastermanual_sg.id ]

  iam_instance_profile = aws_iam_instance_profile.kubmastermanual_agent.name

  tags = {
    Name = "kubernatemaster"
    Application= var.application
  }
}
