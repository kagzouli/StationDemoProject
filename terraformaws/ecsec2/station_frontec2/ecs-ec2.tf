data "aws_ami" "ecs_optimized" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "ec2_stationfront_launch_config" {
    # Optimiser pour docker
    image_id             = data.aws_ami.ecs_optimized.id
    iam_instance_profile = var.aws_instanceprofile_ecsec2 
    security_groups      = [aws_security_group.station_front_c2_sg.id]
    user_data            = file("station_frontec2/initec2front.sh") 
    instance_type        = "t2.micro"
    associate_public_ip_address = false 
    key_name             = "station-front-key-pair"
 
    lifecycle {
       create_before_destroy = true
    }
    
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

   # target_group_arns = [aws_alb_target_group.station_front_target_group.id]
    lifecycle {
        create_before_destroy = true
    }

    tag {
      key                 = "name"
      value               = "ecs-stationfront-ec2"
      propagate_at_launch = true
    }
}
