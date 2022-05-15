# Resource Additional Info
resource "aws_api_gateway_resource" "addiinfo" {
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "additionalInfo"
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

##########################################################################################
# Method additional Information GET
##########################################################################################

resource "aws_api_gateway_method" "addiinfo_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_integration" "addiinfo_get" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.addiinfo.id
  http_method             = aws_api_gateway_method.addiinfo_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.addiinfo_get.invoke_arn
}



# Method additional Information PUT
resource "aws_api_gateway_method" "addiinfo_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}


##########################################################################################
# Method additional Information DELETE
##########################################################################################

resource "aws_api_gateway_method" "addiinfo_delete" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_integration" "addiinfo_delete" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.addiinfo.id
  http_method             = aws_api_gateway_method.addiinfo_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.addiinfo_delete.invoke_arn
}

