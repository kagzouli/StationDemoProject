############### User devops-user ###########################################
resource "aws_iam_user" "devops_user" {
  name = "devops"

  # Comme on est en test , on met true
  force_destroy  = true

  tags = {
     Name = "devops"
     Application= var.application
  }
}

############### Group devops-role#########################################

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


####### Group Policy devops ###################################################

resource "aws_iam_group_policy" "devops_group_policy" {
  name  = "devops"
  group = aws_iam_group.devops_role.name

  policy = templatefile("policies/devops-group.json.tpl",
                    { 
                       ROLE_TO_ASSUME_DEVOPS_STATIONCI  = aws_iam_role.devops_stationci.arn ,
                       ROLE_TO_ASSUME_DEVOPS_CD         = aws_iam_role.devops_cd.arn 
                    }
           ) 
}




