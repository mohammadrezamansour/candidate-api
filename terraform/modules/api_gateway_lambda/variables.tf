variable "config" {
  type = object({
    api_name = string

    lambda_invoke_arn = string
    lambda_function_name = string

        cognito_user_pool_id = string
    cognito_client_id    = string

    stage_name = optional(string, "$default")

    routes = map(object({
      method = string
      path = string
    }))

    tags = map(string)
  })
}