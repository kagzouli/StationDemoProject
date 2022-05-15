#ws_api_gateway_integration Api gateways resources
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

