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

variable "availability_zones" {
  default = {
    dev  = ["eu-west-1a", "eu-west-1b"]
    prod = ["eu-central-1a", "eu-central-1b"]
  }
}

variable "subnet_cidrs" {
  default = {
    dev  = ["10.0.1.0/24", "10.0.2.0/24"]
    prod = ["10.1.1.0/24", "10.1.2.0/24"]
  }
}

variable "environment" {
  description = "The environment for which resources will be provisioned (e.g., dev, prod)"
  type        = string
  default     = "dev"
}