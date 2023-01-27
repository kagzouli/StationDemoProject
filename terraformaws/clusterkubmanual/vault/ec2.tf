# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
  vars = {
    cidr_block_vpc  = data.aws_vpc.station_vpc.cidr_block
  }
}




resource "aws_instance" "kubernatevaultonprem" {
  ami           = data.aws_ami.ecs_optimized.id
  instance_type = "t3.medium"

  user_data     = data.template_file.user_data.rendered 

  subnet_id     = data.aws_subnet.station_privatesubnet1.id

  security_groups = [ aws_security_group.kubvaultonprem_sg.id ]

  iam_instance_profile = aws_iam_instance_profile.kubvaultonprem_agent.name

  key_name      =   aws_key_pair.kubernetesvaultonprem-key-pair.key_name

  tags = {
    Name = "kubernatevaultonprem"
    Application= var.application
  }
}
