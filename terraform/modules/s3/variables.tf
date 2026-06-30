variable "config" {
  description = "S3 bucket configuration"

  type = object({
    bucket_name       = string
    force_destroy     = optional(bool, false)
    enable_versioning = optional(bool, false)
    enable_encryption = optional(bool, true)
    sse_algorithm     = optional(string, "AES256")
    tags              = map(string)
  })

  validation {
    condition = contains(
      ["AES256", "aws:kms"],
      var.config.sse_algorithm
    )

    error_message = "Encryption must be AES256 or aws:kms"
  }
}