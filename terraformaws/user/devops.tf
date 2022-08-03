############### User devops-ci ###########################################
resource "aws_iam_user" "devops_user" {
  name = "devops"

  # Comme on est en test , on met true
  force_destroy  = true

  tags = {
     Name = "devops"
     Application= var.application
  }
}

############### Group devops-ci#########################################

resource "aws_iam_group" "devops_role" {
  name = "devops"
}

resource "aws_iam_user_group_membership" "devops_member" {
  user =  aws_iam_user.devops_user.name 
 
  groups = [
    aws_iam_group.devops_role.name
  ]
}

############ Role policy ##############################################
data "aws_iam_policy_document" "devops_ci_trust_relationship" {
  statement {
    actions = [
        "sts:AssumeRole",
        "sts:TagSession"
    ]
    effect  = "Allow"

    principals {
      identifiers = [aws_iam_user.devops_user.arn]
      type        = "AWS"
    }
  }

}


###### Role ###############################################################
resource "aws_iam_role" "devops_ci" {
  name = "devops-ci"

  assume_role_policy = data.aws_iam_policy_document.devops_ci_trust_relationship.json
}


###### Policy #############################################################
resource "aws_iam_role_policy" "devops_ci" {
  name = "devops-ci"
  role = aws_iam_role.devops_ci.id

  policy = templatefile("policies/devops-ci-role-policy.json.tpl",
                    { 
                      
                    }
           ) 
}




####### Group Policy devops-ci ###################################################

resource "aws_iam_group_policy" "devops_ci" {
  name  = "devops"
  group = aws_iam_group.devops_role.name

  policy = templatefile("policies/devops-group.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = aws_iam_role.devops_ci.arn 
                    }
           ) 
}




