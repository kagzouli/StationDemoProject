# Resource Additional Info
resource "aws_api_gateway_resource" "addiinfo" {
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "additionalInfo"
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

# Method additional Information GET
resource "aws_api_gateway_method" "addiinfo_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}

# Method additional Information PUT
resource "aws_api_gateway_method" "addiinfo_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}

# Method additional Information PATCH
resource "aws_api_gateway_method" "addiinfo_patch" {
  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}

# Method additional Information DELETE 
resource "aws_api_gateway_method" "addiinfo_delete" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.addiinfo.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
}
