variable "config" {

  description = "Lambda configuration"

  type = object({
    function_name = string
    runtime       = string
    handler       = string

    source_dir = string
    role_arn = string

    timeout     = number
    memory_size = number

    environment_variables = map(string)

    tags = map(string)
  })
}