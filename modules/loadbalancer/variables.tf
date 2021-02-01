variable "lb_name" {
  default = "lb-tf"
}

variable "lb_target_name" {
  default = "tf-sub3-lb-tg"
}

variable "target_port" {
  default = 80
}

variable "target_protocol" {
  default = "HTTP"
}

variable "internal" {
  default = true
}

variable "lb_type" {
  default = "application"
}

variable "sub1_id" {}
variable "sub2_id" {}
variable "aws_vpc" {}
variable "aws_security_group" {}
variable "sub3_instance_id" {}