output "arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "The ARN used by API Gateway to invoke the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_name" {
  description = "The name of the deployed Lambda function"
  value       = aws_lambda_function.this.function_name
}