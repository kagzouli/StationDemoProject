# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2.sh")
}


resource "aws_launch_configuration" "kubworker_launch_config" {
    # Optimiser pour docker
    name_prefix          = "kubworker-ec2-instance"
    image_id             = data.aws_ami.ecs_optimized.id
    iam_instance_profile = data.aws_iam_instance_profile.kubworkermanual_agent.name
    security_groups      = [aws_security_group.kubworkermanual_sg.id]
    user_data            = data.template_file.user_data.rendered 
    instance_type        = "t3.large"
    associate_public_ip_address = false 
    key_name             = "kubernetesmaster-key-pair" 
 
    lifecycle {
       create_before_destroy = true
    }
    
}

resource "aws_autoscaling_group" "kubworker_autoscalinggroup" {
    name                      = "kubworker-ec2"
    vpc_zone_identifier       = [data.aws_subnet.station_privatesubnet1.id, data.aws_subnet.station_privatesubnet2.id] 
    launch_configuration      = aws_launch_configuration.kubworker_launch_config.name

    desired_capacity          = 2
    min_size                  = 2 
    max_size                  = 2 
    health_check_grace_period = 300
    health_check_type         = "EC2"

    lifecycle {
        create_before_destroy = true
    }

    tag {
      key                 = "Name"
      value               = "kubworker-ec2"
      propagate_at_launch = true
    }
}
