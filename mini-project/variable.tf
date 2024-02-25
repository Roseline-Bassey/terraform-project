variable "region" {
  description = "AWS region"
  type = string
  default = "eu-west-1"
}

variable "prefix" {
  default = "main"
}

variable "project" {
  default = "terraform-mini-project"
}

variable "contact" {
  default = "roselynbassey23@gmail.com"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_list" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = 3
}
