# Aws launch template
resource "aws_launch_template" "scaleupdown_launch_template" {
  name_prefix =  "scale-updownec2-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size =  30 
      volume_type = "gp2"
    }
  }

  instance_type = "t2.micro" 

  image_id                   = data.aws_ami.ecs_optimized.id

  user_data     = base64encode(data.template_file.user_data.rendered)
  

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "scale-updownec2-launch-template"
      Application= var.application
    }
  }
}


resource "aws_autoscaling_group" "scaleupdown_asg" {
  name                      = "scaleupdown-asg"
  vpc_zone_identifier       = [ data.aws_subnet.station_privatesubnet1.id , data.aws_subnet.station_privatesubnet2.id ]
  desired_capacity          = 0
  max_size                  = 3
  min_size                  = 0

  launch_template {
    id      = aws_launch_template.scaleupdown_launch_template.id
    version = "$Latest"
  }
}