terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.4.0"
    }

  }
}

provider "aws" {
  region = var.ntier_provider.region
}

resource "aws_vpc" "ntier" {
  cidr_block = var.ntier_vpc.cidr_block
  tags = {
    Name = "${var.network_name}-vpc"
  }
}

resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "${var.network_name}-IGW"
  }
}

resource "aws_subnet" "ntier_public" {
  count             = local.subnets_public
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.ntier_vpc.subnets_public[count.index].cidr_block
  availability_zone = var.ntier_vpc.subnets_public[count.index].availability_zone
  tags = {
    Name = var.ntier_vpc.subnets_public[count.index].Name

  }
}


resource "aws_route_table" "ntier_public_route_table" {
  count  = local.subnets_public != 0 ? 1 : 0
  vpc_id = aws_vpc.ntier.id
  tags = {
  Name = "public-rt"
}
  route {
    cidr_block = local.cidr_block
    gateway_id = aws_internet_gateway.ntier_igw.id
  }
}

resource "aws_route_table_association" "ntier_public_route_table_association" {
  count          = local.subnets_public
  subnet_id      = aws_subnet.ntier_public[count.index].id
  route_table_id = aws_route_table.ntier_public_route_table[0].id
}

resource "aws_subnet" "ntier_private" {
  count             = local.subnets_private
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.ntier_vpc.subnets_private[count.index].cidr_block
  availability_zone = var.ntier_vpc.subnets_private[count.index].availability_zone
  tags = {
    Name = var.ntier_vpc.subnets_private[count.index].Name
  }
}

resource "aws_route_table" "ntier_private_route_table" {
  count  = local.subnets_public != 0 ? 1 : 0
  vpc_id = aws_vpc.ntier.id

  route {
    cidr_block     = local.cidr_block
    nat_gateway_id = aws_nat_gateway.ntier_nat.id
  }

}

resource "aws_route_table_association" "ntier_publ_route_table_association" {
  count          = local.subnets_private
  subnet_id      = aws_subnet.ntier_private[count.index].id
  route_table_id = aws_route_table.ntier_private_route_table[0].id
}

resource "aws_eip" "ntier_lb" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ntier_nat" {
  allocation_id = aws_eip.ntier_lb.id
  subnet_id     = aws_subnet.ntier_public[0].id
  tags = {
  Name = "ntier-nat"
}
}

