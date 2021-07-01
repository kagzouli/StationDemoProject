data "aws_caller_identity" "current" {}

resource "aws_iam_role" "external_dns_role" {
  name = "external-dns"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": format(
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:%s", 
            replace(
              "${aws_eks_cluster.station_eks_cluster.identity[0].oidc[0].issuer}", 
              "https://", 
              "oidc-provider/"
            )
          )
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            format(
              "%s:sub", 
              trimprefix(
                "${aws_eks_cluster.station_eks_cluster.identity[0].oidc[0].issuer}", 
                "https://"
              )
            ) : "system:serviceaccount:default:external-dns"
          }
        }
      }
    ]
  })

  depends_on = [aws_eks_cluster.station_eks_cluster]
}
