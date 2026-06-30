terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.config.bucket_name
  force_destroy = var.config.force_destroy
  tags = var.config.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.config.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.config.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.config.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
