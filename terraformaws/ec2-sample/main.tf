# Create security groups for nginx-front.
resource "aws_security_group" "allows_http" {
  name        = "allows_http"
  description = "Allow Http request"
  vpc_id      = data.aws_vpc.station_vpc.id

  ingress {
    protocol    = "HTTP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http request"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

// Nginx front server
resource "aws_instance" "nginx_front" {
	ami = data.aws_ami.ubuntu.id
	instance_type = "t2.nano"
    associate_public_ip_address = true
    subnet_id     = data.aws_subnet.station_publicsubnet1.id
    user_data     = file("ec2-sample/install_nginx_front.sh")
	security_groups = [aws_security_group.allows_http.id]
    tags = {
		Name = "nginx-front"	
		Batch = "5AM"
	}

}

