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

############### Group devops-ci#########################################

resource "aws_iam_group" "devops_ci" {
  name = "devops-ci"
}

resource "aws_iam_user_group_membership" "devops_ci" {
  user =  aws_iam_user.devops_ci.name 
 
  groups = [
    aws_iam_group.devops_ci.name
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
      identifiers = [aws_iam_user.devops_ci.arn]
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
  name  = "devops-ci"
  group = aws_iam_group.devops_ci.name

  policy = templatefile("policies/devops-ci-group.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = aws_iam_role.devops_ci.arn 
                    }
           ) 
}




