data "archive_file" "lambda" {
  type = "zip"

  source_dir = var.config.source_dir

  output_path = "${path.root}/.terraform/lambda.zip"
}
resource "aws_lambda_function" "this" {

  function_name = var.config.function_name

  runtime = var.config.runtime

  handler = var.config.handler

  filename         = data.archive_file.lambda.output_path

  source_code_hash = data.archive_file.lambda.output_base64sha256

  role = var.config.role_arn

  timeout = var.config.timeout

  memory_size = var.config.memory_size

  environment {

    variables = var.config.environment_variables

  }

  tags = var.config.tags
}