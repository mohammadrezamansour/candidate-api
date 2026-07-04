variable "config" {
  description = "DynamoDB table configuration"

  type = object({
    table_name   = string
    billing_mode = string
    hash_key     = string
    read_capacity  = optional(number)
    write_capacity = optional(number)
    attributes = list(object({
      name = string
      type = string
    }))
    enable_pitr = optional(bool, false)
    enable_encryption = optional(bool, false)
    kms_key_arn = optional(string)
    tags = map(string)
  })


validation {
    condition = contains(
      ["PROVISIONED", "PAY_PER_REQUEST"],
      var.config.billing_mode
    )

    error_message = "Invalid billing mode"
  }
validation {
    condition = (
      var.config.billing_mode == "PAY_PER_REQUEST" ||
      (
        var.config.billing_mode == "PROVISIONED" &&
        var.config.read_capacity != null &&
        var.config.write_capacity != null
      )
    )

    error_message = "When billing_mode is PROVISIONED, read_capacity and write_capacity must be specified."
  }
validation {
  condition = (!var.config.enable_encryption || var.config.kms_key_arn != null)
  error_message = "kms arn key is required when side server encryption is enable "
}
}