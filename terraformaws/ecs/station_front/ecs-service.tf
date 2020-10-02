

// Nginx front server
resource "aws_instance" "nginx_front" {
	ami = data.aws_ami.ubuntu.id
	instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id     = var.public_subnet1_id
    user_data     = file("ec2-sample/install_nginx_front.sh")
	security_groups = [aws_security_group.allows_http.id]
    tags = {
		Name = "nginx-front"	
		Application= var.application
	}

}

