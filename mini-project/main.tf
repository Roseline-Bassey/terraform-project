resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-vpc" })
  )
}

resource "aws_subnet" "subnet_1" {
  cidr_block              = var.subnet_cidr_list[0]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-1a"

  tags = merge(
    local.common_tags,
    tomap({ "Namw" = "${local.prefix}-public" })
  )
}

resource "aws_subnet" "subnet_2" {
  cidr_block              = var.subnet_cidr_list[1]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-1b"

  tags = merge(
    local.common_tags,
    tomap({ "Namw" = "${local.prefix}-public" })
  )
}

resource "aws_subnet" "subnet_3" {
  cidr_block              = var.subnet_cidr_list[2]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-1c"

  tags = merge(
    local.common_tags,
    tomap({ "Namw" = "${local.prefix}-public" })
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({ "Namw" = "${local.prefix}-main" })
  )
}

# resource "aws_eip" "public" {
#    tags = merge(
#     local.common_tags,
#     tomap({ "Namw" = "${local.prefix}-public" })
#   )
# }

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({ "Namw" = "${local.prefix}-public" })
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.public.id

}

resource "aws_security_group" "ec2-instance" {
  description = "Allow inbound and outbound traffic to EC2 instances from load balancer security group"
  name        = "${local.prefix}-ssh_access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.sg_for_lb.id]
    cidr_blocks     = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_security_group" "sg_for_lb" {
  name   = "main-sg_for_lb"
  vpc_id = aws_vpc.main.id

  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
