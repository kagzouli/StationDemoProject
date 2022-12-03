# Aws launch template
resource "aws_launch_template" "station_eks_launch_template" {
  name_prefix =  "scale-updownec2-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size =  20 
      volume_type = "gp2"
    }
  }

  instance_type = "t2.micro" 

  user_data     = base64encode(data.template_file.user_data.rendered)
  

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "scale-updownec2-launch-template"
      Application= var.application
    }
  }
}