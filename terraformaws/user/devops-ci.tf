
####### Group devops-ci ###################################################
resource "aws_iam_group" "station_devops_ci" {
  name = "devops-ci"
}


resource "aws_iam_group_policy" "devops_ci" {
  name  = "devops-ci"
  group = aws_iam_group.station_devops_ci.name

  policy = templatefile("policies/devops-ci-group-policies.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops-ci"   
                    }
           ) 
}



############### User devops-ci ###########################################
resource "aws_iam_user" "station_devops_ci" {
  name = "devops-ci"

  # Comme on est en test , on met true
  force_destroy  = true

  tags = {
     Name = "devops-ci"
     Application= var.application
  }
}


resource "aws_iam_user_group_membership" "station_devops_ci" {
  user =  aws_iam_user.station_devops_ci.name 
 
  groups = [
    aws_iam_group.station_devops_ci.name
  ]
}



