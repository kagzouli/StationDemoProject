# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
  vars = {
    cidr_block_vpc  = data.aws_vpc.station_vpc.cidr_block
  }
}




resource "aws_instance" "minikube" {
  ami           = data.aws_ami.ubuntu-linux.id
  instance_type = "t3.large"

  user_data     = data.template_file.user_data.rendered 

  subnet_id     = data.aws_subnet.station_publicsubnet1.id

  security_groups = [ aws_security_group.minikube_sg.id ]

  iam_instance_profile = aws_iam_instance_profile.minikube_agent.name

  key_name      =   aws_key_pair.minikube-key-pair.key_name

  associate_public_ip_address = "true"

  tags = {
    Name = "minikube"
    Application= var.application
  }
}
