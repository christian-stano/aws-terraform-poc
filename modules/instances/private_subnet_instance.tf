data "aws_vpc" "default" {
  id = var.aws_vpc
}

data "aws_ami" "redhat_linux_private" {
  most_recent = true
  owners = ["309956199498"]

  filter {
    name = "name"
    values = [var.ami]
  }
}

resource "aws_instance" "sub3_instance" {
  ami = data.aws_ami.redhat_linux_private.id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id
  key_name = var.key_name
  security_groups = [aws_security_group.ec2_allow_ssh.id]
  user_data = file("${path.module}/apache_install.sh")

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "PrivateEC2Apache"
  }
}

