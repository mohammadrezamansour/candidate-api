variable "config" {
  description = "DynamoDB table configuration"

  type = object({
    table_name   = string
    billing_mode = string
    hash_key     = string

    attributes = list(object({
      name = string
      type = string
    }))

    tags = map(string)
  })


validation {
    condition = contains(
      ["PROVISIONED", "PAY_PER_REQUEST"],
      var.config.billing_mode
    )

    error_message = "Invalid billing mode"
  }
}