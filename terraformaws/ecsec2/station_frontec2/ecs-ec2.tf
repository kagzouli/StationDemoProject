data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "ec2_stationfront_launch_config" {
    # Optimiser pour docker
    image_id             = data.aws_ami.ubuntu.id 
    iam_instance_profile = var.aws_instanceprofile_ecsec2 
    security_groups      = [aws_security_group.sg_station_front_ecs.id]
    user_data            = file("station_frontec2/initec2front.sh") 
    instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "ec2_stationfront_autoscalinggroup" {
    name                      = "ec2-stationfront-autoscaling"
    vpc_zone_identifier       = var.private_subnets_id 
    launch_configuration      = aws_launch_configuration.ec2_stationfront_launch_config.name

    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 3 
    health_check_grace_period = 300
    health_check_type         = "EC2"

    tag {
      key                 = "name"
      value               = "ecs-stationfront-ec2"
      propagate_at_launch = true
    }
}
