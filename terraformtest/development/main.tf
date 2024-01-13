module "vpc" {
  source            = "../modules/vpc"
  region            = var.region
  vpc_cidr          = var.vpc_cidr[var.environment]
  availability_zones = var.availability_zones[var.environment]
  subnet_cidrs      = var.subnet_cidrs[var.environment]
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "route_table" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "route_subnet" {
  count          = length(module.vpc.subnet_ids)
  subnet_id      = element(module.vpc.subnet_ids, count.index)
  route_table_id = aws_route_table.route_table.id
}

module "ec2_instance" {
  source            = "../modules/ec2-instances"
  region            = var.region
  ssh_key_name      = var.ssh_key_name
  private_key_path  = var.private_key_path
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.subnet_ids
  availability_zone = element(var.availability_zones[var.environment], 0)
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "instance-dns" {
  value = module.ec2_instance.public_dns
}