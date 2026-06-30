terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
  }
}

resource "aws_cognito_user_pool" "this" {
  name = var.config.user_pool_name
  tags = var.config.tags
}

resource "aws_cognito_resource_server" "this" {
  identifier   = var.config.resource_server_identifier
  name         = var.config.resource_server_name
  user_pool_id = aws_cognito_user_pool.this.id

  scope {
    scope_name        = var.config.scope_name
    scope_description = var.config.scope_description
  }
}

resource "aws_cognito_user_pool_client" "this" {

  name = var.config.client_name
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = true

  allowed_oauth_flows = [
    "client_credentials"
  ]

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_scopes = [
    "${aws_cognito_resource_server.this.identifier}/${var.config.scope_name}"
  ]

  supported_identity_providers = [
    "COGNITO"
  ]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.config.domain
  user_pool_id = aws_cognito_user_pool.this.id
}