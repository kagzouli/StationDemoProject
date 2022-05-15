#aws_api_gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "station-apigateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
      Name = "station-apigateway"
      Application= var.application
  }

}

resource "aws_api_gateway_deployment" "station__deployment" {

  rest_api_id       = aws_api_gateway_rest_api.api_gateway.id

  #lifecyle pour empecher les erreurs au redéploiement du stage
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_api_gateway_stage" "station__stage" {
  deployment_id = aws_api_gateway_deployment.station__deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = "v1"

  tags = {
      Name = "station-apigateway-v1"
      Application= var.application
  }

}



resource "aws_acm_certificate" "public_cert" {
  domain_name       = "pocapi.${var.station_publicdomainname}"
  validation_method = "EMAIL"

  validation_option {
    domain_name       = "pocapi.${var.station_publicdomainname}"
    validation_domain = "${var.station_publicdomainname}"
  }
}


resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = "pocapi.${var.station_publicdomainname}"
  regional_certificate_arn = aws_acm_certificate.public_cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}


resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id     = aws_api_gateway_rest_api.api_gateway.id

  domain_name = aws_api_gateway_domain_name.domain.domain_name

  base_path = ""

}
