output "user_pool_id" {
  description = "The ID of the Cognito User Pool."
  value       = aws_cognito_user_pool.this.id
}

output "client_id" {
  description = "The ID of the Cognito User Pool client."
  value       = aws_cognito_user_pool_client.this.id
}

output "client_secret" {
  description = "The client secret of the Cognito User Pool client."
  value       = aws_cognito_user_pool_client.this.client_secret
}