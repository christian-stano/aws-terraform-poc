terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  name = "AWS-POC-VPC"
  region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  project = "AWS-POC"
  environment = "Sandbox"
}

module "instances" {
  source = "./modules/instances"
  aws_vpc = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet3_id
  public_subnet_id = module.vpc.public_subnet1_id
  key_name = "ec2-test"
}