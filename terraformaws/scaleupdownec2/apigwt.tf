#aws_api_gateway
resource "aws_api_gateway_rest_api" "scaleupdown_gateway" {
  name = "scaleupdown-apigateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
      Name = "scaleup-apigateway"
      Application= var.application
  }

}



##########################################################################################
# Scale up
##########################################################################################

resource "aws_api_gateway_resource" "scale_up" {
  parent_id   = aws_api_gateway_rest_api.scaleupdown_gateway.root_resource_id
  path_part   = "scaleUp"
  rest_api_id = aws_api_gateway_rest_api.scaleupdown_gateway.id
}


resource "aws_api_gateway_method" "scale_up" {
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.scale_up.id
  rest_api_id   = aws_api_gateway_rest_api.scaleupdown_gateway.id
  authorization = "NONE"

}


resource "aws_api_gateway_integration" "scale_up" {
  rest_api_id             = aws_api_gateway_rest_api.scaleupdown_gateway.id
  resource_id             = aws_api_gateway_resource.scale_up.id
  http_method             = aws_api_gateway_method.scale_up.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.scale_up.invoke_arn
}


##########################################################################################
# Scale down
##########################################################################################

resource "aws_api_gateway_resource" "scale_down" {
  parent_id   = aws_api_gateway_rest_api.scaleupdown_gateway.root_resource_id
  path_part   = "scaleDown"
  rest_api_id = aws_api_gateway_rest_api.scaleupdown_gateway.id
}


resource "aws_api_gateway_method" "scale_down" {
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.scale_down.id
  rest_api_id   = aws_api_gateway_rest_api.scaleupdown_gateway.id
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "scale_down" {
  rest_api_id             = aws_api_gateway_rest_api.scaleupdown_gateway.id
  resource_id             = aws_api_gateway_resource.scale_down.id
  http_method             = aws_api_gateway_method.scale_down.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.scale_down.invoke_arn
}
