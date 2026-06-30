variable "config" {

  description = "Cognito configuration"

  type = object({

    user_pool_name = string
    client_name = string
    resource_server_identifier = string
    resource_server_name       = string
    scope_name                 = string
    scope_description          = string
    domain = string

    tags = map(string)

  })
}