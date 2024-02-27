resource "aws_instance" "app-server" {
  count                  = length(var.subnet_cidr_list)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2-instance.id, ]
  key_name               = "ssh-key"
  availability_zone      = var.availability_zone

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public-ec2" })
  )

}
