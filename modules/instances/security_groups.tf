resource "aws_security_group" "ec2_allow_ssh" {
  name = "ec2_allow_ssh"
  description = "Allow SSH inbound and outbound traffic"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_allow_http" {
  name = "ec2_allow_http"
  description = "Allow HTTP inbound and outbound traffic"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

output "ec2_allow_http" {
  value = aws_security_group.ec2_allow_http.id
}

