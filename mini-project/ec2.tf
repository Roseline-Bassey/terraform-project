resource "aws_instance" "public" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.ssh.id,]
  key_name = "ssh-key"
  availability_zone = "${data.aws_region.current}a"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public-ec2" })
  )
  
}
