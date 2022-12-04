#aws_api_gateway
resource "aws_api_gateway_rest_api" "scaleupdown_gateway" {
  name = "scaleec2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
      Name = "scaleup-apigateway"
      Application= var.application
  }

}

resource "aws_api_gateway_deployment" "scaleupdown_deployment" {

  rest_api_id       = aws_api_gateway_rest_api.scaleupdown_gateway.id

  #lifecyle pour empecher les erreurs au redéploiement du stage
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_api_gateway_stage" "scaleupdown_stage" {
  deployment_id = aws_api_gateway_deployment.scaleupdown_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.scaleupdown_gateway.id
  stage_name    = "v1"

  tags = {
      Name = "scaleupdown-apigateway-v1"
      Application= var.application
  }

}



resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = "${var.station_publicdomainname}"
  regional_certificate_arn = data.aws_acm_certificate.public_cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}


resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id     = aws_api_gateway_rest_api.scaleupdown_gateway.id

  domain_name = aws_api_gateway_domain_name.domain.domain_name

  stage_name  = aws_api_gateway_stage.scaleupdown_stage.stage_name

  base_path = ""

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
  http_method   = "POST"
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
  http_method   = "POST"
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
