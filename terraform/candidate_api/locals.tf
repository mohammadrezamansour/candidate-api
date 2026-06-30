locals {
  name = "${var.project_name}-${var.environment}"
  default_tags = {
    ManagedBy = "Terraform"
  }
}