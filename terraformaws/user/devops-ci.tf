###### Policy #############################################################
resource "aws_iam_role_policy" "devops_ci" {
  name = "devops-ci"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("policies/devops-ci-role-policy.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops-ci"   
                    }
           ) 
}


###### Role ###############################################################
resource "aws_iam_role" "devops_ci" {
  name = "devops-ci"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}



####### Group devops-ci ###################################################
resource "aws_iam_group" "devops_ci" {
  name = "devops-ci"
}


resource "aws_iam_group_policy" "devops_ci" {
  name  = "devops-ci"
  group = aws_iam_group.devops_ci.name

  policy = templatefile("policies/devops-ci-group.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops-ci"   
                    }
           ) 
}



############### User devops-ci ###########################################
resource "aws_iam_user" "devops_ci" {
  name = "devops-ci"

  # Comme on est en test , on met true
  force_destroy  = true

  tags = {
     Name = "devops-ci"
     Application= var.application
  }
}


resource "aws_iam_user_group_membership" "devops_ci" {
  user =  aws_iam_user.devops_ci.name 
 
  groups = [
    aws_iam_group.devops_ci.name
  ]
}



