resource "aws_api_gateway_authorizer" "station_authorizer" {
  name                   = "station-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api_gateway.id
  authorizer_uri         = aws_lambda_function.lambda_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.station_authorizer_iam_role.arn
  type                   = "REQUEST"

  authorizer_result_ttl_in_seconds = 0
}


resource "aws_iam_role" "station_authorizer_iam_role" {
  name = "station--iam-role"

  path = "/"
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

resource "aws_iam_role_policy" "station_authorizer_iam_policy" {
  name = "station-authotizer-iam-policy"
  role = aws_iam_role.station_authorizer_iam_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "lambda:InvokeFunction",
        "Effect" : "Allow",
        "Resource" : "${aws_lambda_function.lambda_authorizer.arn}"
      }
    ]
  })
}




