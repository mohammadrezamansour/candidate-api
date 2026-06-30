terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
  }
}

data "aws_region" "current" {}

resource "aws_apigatewayv2_api" "this" {
  name          = var.config.api_name
  protocol_type = "HTTP"
  
  tags = var.config.tags
}

resource "aws_apigatewayv2_integration" "this" {

  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"
  integration_uri = var.config.lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "this" {

  for_each = var.config.routes

  api_id = aws_apigatewayv2_api.this.id
  route_key = "${each.value.method} ${each.value.path}"
  target = "integrations/${aws_apigatewayv2_integration.this.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.this.id

}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id

  name        = var.config.stage_name
  auto_deploy = true
}

resource "aws_lambda_permission" "apigateway" {

  statement_id = "AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = var.config.lambda_function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_authorizer" "this" {

  api_id = aws_apigatewayv2_api.this.id

  name = "cognito"

  authorizer_type = "JWT"

  identity_sources = [
    "$request.header.Authorization"
  ]

  jwt_configuration {

    audience = [
      var.config.cognito_client_id
    ]

    issuer = "https://cognito-idp.${data.aws_region.current.region}.amazonaws.com/${var.config.cognito_user_pool_id}"
  }
}