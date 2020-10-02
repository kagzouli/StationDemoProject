// Nginx front server
resource "aws_instance" "nginx_front" {
	ami = aws_ami.amazon-linux-2.id
	instance_type = "t2.nano"
    associate_public_ip_address = true
    subnet_id     = aws_subnet.station_publicsubnet1.id
    user_data     = file("install_nginx_front.sh")
	tags = {
		Name = "Terraform"	
		Batch = "5AM"
	}
}