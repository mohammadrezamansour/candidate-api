variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "s3_buckets" {
  description = "S3 buckets"

  type = map(object({
    force_destroy     = bool
    enable_versioning = bool
    enable_encryption = bool
    sse_algorithm     = string
    tags              = optional(map(string), {})
  }))
}

variable "dynamodb_tables" {
  description = "DynamoDB tables"

  type = map(object({
    billing_mode = string
    hash_key     = string

    attributes = list(object({
      name = string
      type = string
    }))

    tags = optional(map(string), {})
  }))
}


variable "lambda" {
  description = "Lambda configuration"

  type = object({
    runtime = string
    handler = string

    source_dir = string

    timeout     = optional(number, 30)
    memory_size = optional(number, 128)

    environment_variables = optional(map(string), {})

    tags = optional(map(string), {})
  })
}

variable "api_gateway" {
  description = "API Gateway configuration"

  type = object({
    stage_name = string

    routes = map(object({
      method = string
      path   = string
    }))

    tags = optional(map(string), {})
  })
}

variable "cognito" {

  description = "Cognito configuration"

  type = object({

    domain            = string
    scope_name        = string
    scope_description = string
    tags              = optional(map(string), {})

  })
}