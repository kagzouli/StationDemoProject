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