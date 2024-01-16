variable "region" {}
variable "ssh_key_name" {}
variable "private_key_path" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "availability_zone" {}

 # SECURITY_GROUP
 
resource "aws_security_group" "sg_instance" {
  name = "server1_sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instances" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = element(var.subnet_ids, 0)
  vpc_security_group_ids = [aws_security_group.sg_instance.id]
  key_name               = var.ssh_key_name
  availability_zone      = var.availability_zone

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
}

output "public_dns" {
  value = aws_instance.ec2_instances.public_dns
}
