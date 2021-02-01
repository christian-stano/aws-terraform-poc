variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

# Amazon Linux AMI
variable "ami" {
  default = "RHEL*x86*"
}

variable "volume_size" {
  default = "20"
}

variable "key_name" {}

variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "aws_vpc" {}

