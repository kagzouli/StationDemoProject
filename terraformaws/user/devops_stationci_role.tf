#################### Role policy devops-ci #######################################

resource "aws_iam_role" "devops_stationci" {
  name = "devops-stationci"

  assume_role_policy = data.aws_iam_policy_document.devops_trust_relationship.json
}


resource "aws_iam_role_policy" "devops_stationci" {
  name = "devops-stationci"
  role = aws_iam_role.devops_stationci.id

  policy = templatefile("policies/devops-stationci-role-policy.json.tpl",
                    { 
                      
                    }
           ) 
}