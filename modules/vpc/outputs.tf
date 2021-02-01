output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnet1_id" {
  value = aws_subnet.public1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public2.id
}

output "private_subnet3_id" {
  value = aws_subnet.private3.id
}

output "private_subnet3_ipv4" {
  value = aws_subnet.private3.cidr_block
}

output "private_subnet4_id" {
  value = aws_subnet.private4.id
}

output "private_subnet4_ipv4" {
  value = aws_subnet.private4.cidr_block
}