# Datasources
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


data "aws_iam_policy_document" "machinesql_role_iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "machinesql_role_iam_role" {
  name               = "machinesql-role"
  assume_role_policy = data.aws_iam_policy_document.machinesql_role_iam_policy_document.json
}


resource "aws_iam_role_policy_attachment" "assume_role_ec2role" {
  role       = aws_iam_role.machinesql_role_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "assume_role_cloudwatch_policy" {
  role       =  aws_iam_role.machinesql_role_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "assume_role_ssmmanagedinstance_policy" {
  role       = aws_iam_role.machinesql_role_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "machinesql_iam_profile" {
  name = "machinesql-iam-profile"
  role = aws_iam_role.machinesql_role_iam_role.name
}


# EC2 cluster instances - booting script
data "template_file" "user_data" {
  template = file("${path.module}/initec2db.sh")
  vars = {
     stationdb_user      = var.station_db_username
     stationdb_pwd       = var.station_db_password
     stationdb_hostname  = aws_rds_cluster.station_db_rds_cluster.endpoint 
  }
}


resource "aws_instance" "machinesql" {
  ami                  = data.aws_ami.ecs_optimized.id
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnet.station_privatesubnet1.id
  iam_instance_profile = aws_iam_instance_profile.machinesql_iam_profile.name
  user_data            = data.template_file.user_data.rendered 
  security_groups      = [aws_security_group.station_db_c2_sg.id]

  depends_on = [
     aws_rds_cluster_instance.rds_instance 
  ]  

  tags = {
     Name = "machinesql"
     Application= var.application
  }

}

