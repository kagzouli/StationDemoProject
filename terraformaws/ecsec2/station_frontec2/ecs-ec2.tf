
#Datasource 
data "aws_ami" "ecs_optimized" {
  most_recent = true
  filter {
    name   = "name"
    values = ["*ecs-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}


# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2front.sh")
  vars = {
    ecs_cluster_name  = aws_ecs_cluster.station_front_ecs_cluster.name
  }
}



resource "aws_launch_configuration" "ec2_stationfront_launch_config" {
    # Optimiser pour docker
    name_prefix          = "stationfront-ec2-instance"
    image_id             = data.aws_ami.ecs_optimized.id
    iam_instance_profile = var.aws_instanceprofile_ecsec2 
    security_groups      = [aws_security_group.station_front_c2_sg.id]
    user_data            = data.template_file.user_data.rendered 
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
