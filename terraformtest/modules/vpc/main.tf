variable "region" {}
variable "vpc_cidr" {}
variable "availability_zones" {}
variable "subnet_cidrs" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet" {
  count             = length(var.availability_zones)
  cidr_block        = element(var.subnet_cidrs, count.index)
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zones, count.index)
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}
