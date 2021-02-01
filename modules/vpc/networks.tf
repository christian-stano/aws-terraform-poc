#
# VPC resources
#
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
  {
    Name = var.name
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = merge(
  {
    Name = "gwInternet"
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}
output "vpc_id" {
  value = aws_vpc.default.id
}

#
# Public Subnets
#
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]
  tags = merge(
  {
    Name = "terraform_public_subnet1"
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}
output "public_subnet1_id" {
  value = aws_subnet.public1.id
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]
  tags = merge(
  {
    Name = "terraform_public_subnet2"
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}
output "public_subnet2_id" {
  value = aws_subnet.public2.id
}

#
# Public Subnet Internet Access
#

# Allow internet access to public subnet 1
resource "aws_route_table" "public_1_internet" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = merge(
  {
    Name = "terraform_public_subnet1_route_table"
  },
  var.tags)
}

resource "aws_route_table_association" "internet_for_public_1" {
  route_table_id = aws_route_table.public_1_internet.id
  subnet_id = aws_subnet.public1.id
}

# Allow internet access to public subnet 2
resource "aws_route_table" "public_2_internet" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = merge(
  {
    Name = "terraform_public_subnet2_route_table"
  },
  var.tags)
}
resource "aws_route_table_association" "internet_for_public_2" {
  route_table_id = aws_route_table.public_2_internet.id
  subnet_id = aws_subnet.public2.id
}

#
# Private Subnets
#
resource "aws_subnet" "private3" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]
  tags = merge(
  {
    Name = "terraform_private_subnet3"
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}

output "private_subnet3_id" {
  value = aws_subnet.private3.id
}

output "private_subnet3_ipv4" {
  value = aws_subnet.private3.cidr_block
}

resource "aws_subnet" "private4" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]
  tags = merge(
  {
    Name = "terraform_private_subnet4"
    Project = var.project
    Environment = var.environment
  },
  var.tags)
}

output "private_subnet4_id" {
  value = aws_subnet.private4.id
}