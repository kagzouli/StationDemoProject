// Nginx front server
resource "aws_instance" "nginx_front" {
	ami = data.aws_ami.ubuntu.id
	instance_type = "t2.nano"
    associate_public_ip_address = true
    subnet_id     = data.aws_subnet.station_publicsubnet1.id
    user_data     = file("ec2-sample/install_nginx_front.sh")
	tags = {
		Name = "nginx-front"	
		Batch = "5AM"
	}
}