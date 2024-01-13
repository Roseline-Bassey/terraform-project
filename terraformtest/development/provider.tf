# terraform {
#     required_providers {
#       aws = {
#         source = "hashicorp/aws"
#         version = "5.30.0"
#       }
#     }
# }

# provider "aws" {
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
#   region     = var.region
# }
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}