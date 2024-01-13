# VARIABLES

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "ssh_key_name" {}
variable "private_key_path" {}

variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  default = {
    dev  = "10.0.0.0/16"
    prod = "10.1.0.0/16"
  }
}

variable "environment" {
  description = "The environment for which resources will be provisioned (e.g., dev, prod)"
  type        = string
  default     = "prod"
}