output "sub1_instance" {
  value = aws_instance.sub1_instance.id
}

output "sub3_instance" {
  value = aws_instance.sub3_instance.id
}

output "ec2_allow_http" {
  value = aws_security_group.ec2_allow_http.id
}

output "ec2_allow_ssh" {
  value = aws_security_group.ec2_allow_ssh.id
}

