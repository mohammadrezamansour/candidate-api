output "api_endpoint" {
  description = "The endpoint URL of the API Gateway HTTP API."
  value       = aws_apigatewayv2_stage.this.invoke_url
}