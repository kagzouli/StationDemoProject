// Nginx front server
resource "aws_instance" "nginx_front" {
	ami = aws_ami.amazon-linux-2.id
	instance_type = "t2.nano"
    subnet_id     = aws_subnet.station_publicsubnet1.id
	user_data = << EOF
     #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    EOF
	tags = {
		Name = "Terraform"	
		Batch = "5AM"
	}
}