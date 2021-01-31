data "aws_ami" "redhat_linux_public" {
  most_recent = true
  owners = ["309956199498"]

  filter {
    name = "name"
    values = [var.ami]
  }
}

resource "aws_instance" "sub1_instance" {
  ami = data.aws_ami.redhat_linux_public.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.ec2_allow_ssh.id,aws_security_group.ec2_allow_http.id]
  subnet_id = var.public_subnet_id
  key_name = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "PublicEC2Base"
  }
}

