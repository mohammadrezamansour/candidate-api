output "api_endpoint" {
  description = "HTTP API endpoint"
  value       = module.api_gateway.api_endpoint
}

output "cognito_client_id" {
  description = "Cognito OAuth client ID"
  value       = module.cognito.client_id
}

output "cognito_client_secret" {
  description = "Cognito OAuth client secret"
  value       = module.cognito.client_secret
  sensitive   = true
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}