# Locals let you centrally manage the common variables used in your configuration.

locals {
  prefix = var.prefix
  common_tags = {
    Project    = var.project
    Contact    = var.contact
    Managed_by = "Terraform"
  }
}