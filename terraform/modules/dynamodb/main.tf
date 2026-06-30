terraform {
  required_version = ">= 1.15.7"

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

  dynamic "attribute" {
    for_each = var.config.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = var.config.tags
}