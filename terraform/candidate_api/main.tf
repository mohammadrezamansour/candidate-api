module "s3" {
  source = "../modules/s3"

  for_each = var.s3_buckets

  config = merge(each.value, {
    bucket_name = local.name
    tags = merge(local.default_tags, each.value.tags)
  })
}
module "dynamodb" {
  source = "../modules/dynamodb"

  for_each = var.dynamodb_tables

  config = merge(each.value, {
    table_name = local.name
    tags = merge(local.default_tags, each.value.tags)
  })
}
module "lambda" {
  source = "../modules/lambda"

  config = {
    function_name = local.name
    runtime       = var.lambda.runtime
    handler       = var.lambda.handler
    source_dir    = "${path.root}/${var.lambda.source_dir}"

    role_arn = aws_iam_role.lambda.arn

    timeout     = var.lambda.timeout
    memory_size = var.lambda.memory_size

    environment_variables = merge(
      var.lambda.environment_variables,
      {
        S3_BUCKET      = module.s3["resume"].bucket_name
        DYNAMODB_TABLE = module.dynamodb["candidates"].table_name
      }
    )

    tags = merge(local.default_tags, var.lambda.tags)
  }
}

module "api_gateway" {

  source = "../modules/api_gateway_lambda"

  config = merge(var.api_gateway, {

    api_name = local.name

    lambda_invoke_arn = module.lambda.invoke_arn

    lambda_function_name = module.lambda.function_name

    cognito_user_pool_id = module.cognito.user_pool_id
    cognito_client_id    = module.cognito.client_id

    tags = merge(local.default_tags, var.api_gateway.tags)

  })
}

module "cognito" {
  source = "../modules/cognito"

  config = {
    user_pool_name = "${var.project_name}_pool"

    client_name = "${var.project_name}_client"

    resource_server_identifier = "${var.project_name}"

    resource_server_name = "${var.project_name}"

    domain = var.cognito.domain

    scope_name = var.cognito.scope_name
    scope_description = var.cognito.scope_description

    tags = merge(local.default_tags, var.cognito.tags)

  }
}