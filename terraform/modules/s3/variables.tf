variable "config" {
  description = "S3 bucket configuration"

  type = object({
    bucket_name       = string
    bucket_prefix     = string
    force_destroy     = bool
    enable_versioning = bool
    enable_encryption = bool
    sse_algorithm     = string
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