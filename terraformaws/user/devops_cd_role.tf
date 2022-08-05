#################### Role policy devops-cd #######################################

resource "aws_iam_role" "devops_cd" {
  name = "devops-cd"

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
