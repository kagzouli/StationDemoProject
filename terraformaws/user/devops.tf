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

############ Trust relationship  ##############################################
data "aws_iam_policy_document" "devops_trust_relationship" {
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


#################### Role policy devops-ci #######################################

resource "aws_iam_role" "devops_ci" {
  name = "devops-ci"

  assume_role_policy = data.aws_iam_policy_document.devops_trust_relationship.json
}


resource "aws_iam_role_policy" "devops_ci" {
  name = "devops-ci"
  role = aws_iam_role.devops_ci.id

  policy = templatefile("policies/devops-ci-role-policy.json.tpl",
                    { 
                      
                    }
           ) 
}


#################### Role policy devops-cd #######################################

resource "aws_iam_role" "devops_cd" {
  name = "devops-ci"

  assume_role_policy = data.aws_iam_policy_document.devops_trust_relationship.json
}


resource "aws_iam_role_policy" "devops_cd" {
  name = "devops-cd"
  role = aws_iam_role.devops_cd.id

  policy = templatefile("policies/devops-cd-role-policy.json.tpl",
                    { 
                      
                    }
           ) 
}



####### Group Policy devops ###################################################

resource "aws_iam_group_policy" "devops_group_policy" {
  name  = "devops"
  group = aws_iam_group.devops_role.name

  policy = templatefile("policies/devops-group.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_CI = aws_iam_role.devops_ci.arn ,
                       ROLE_TO_ASSUME_DEVOPS_CD = aws_iam_role.devops_cd.arn 
                    }
           ) 
}




