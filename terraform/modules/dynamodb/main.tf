terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
  }
}

resource "aws_dynamodb_table" "this" {

  name         = var.config.table_name
  billing_mode = var.config.billing_mode
  hash_key     = var.config.hash_key

  read_capacity  = var.config.billing_mode == "PROVISIONED" ? var.config.read_capacity : null
  write_capacity = var.config.billing_mode == "PROVISIONED" ? var.config.write_capacity : null


  dynamic "attribute" {
    for_each = var.config.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
  point_in_time_recovery {
  enabled = var.config.enable_pitr
}

dynamic "server_side_encryption" {
  for_each = var.config.enable_encryption ? [1] : []

  content {
    enabled     = true
    kms_key_arn = var.config.kms_key_arn
  }
}

  tags = var.config.tags
}