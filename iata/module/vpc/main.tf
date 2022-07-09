resource "aws_vpc" "this" {
  count                = var.enable == "true" ? 1 : 0
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge({
    Name = format("%s-%s-vpc", var.app, var.env)
  }, var.tags)
}

resource "aws_subnet" "private" {
  count = var.enable == "true" ? length(var.private_cidr_block) : 0
  #count                   = length(var.private_cidr_block)
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = element(var.private_cidr_block, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false
  tags = merge({
    Name = format("%s-%s-private-%s", var.app, var.env, element(var.availability_zone, count.index))
  }, var.tags)
}

resource "aws_subnet" "public" {
  count = var.enable == "true" ? length(var.public_cidr_block) : 0
  #count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = element(var.public_cidr_block, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = merge({
    Name = format("%s-%s-public-%s", var.app, var.env, element(var.availability_zone, count.index))
  }, var.tags)
}

resource "aws_subnet" "database" {
  count      = var.enable == "true" ? length(var.database_cidr_block) : 0
  vpc_id     = aws_vpc.this[0].id
  cidr_block = element(var.database_cidr_block, count.index)
  #availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false
  tags = merge({
    Name = format("%s-%s-database-%s", var.app, var.env, element(var.availability_zone, count.index))
  }, var.tags)
}

resource "aws_internet_gateway" "gw" {
  count  = var.enable == "true" ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  tags = merge({
    Name = format("%s-%s-igw", var.app, var.env)
  }, var.tags)
}


resource "aws_route_table" "public_rt" {
  count  = var.enable == "true" ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }
  tags = merge({
    Name = format("%s-%s-public-rt", var.app, var.env)
  }, var.tags)
}

resource "aws_route_table_association" "public" {
  count = var.enable == "true" ? length(var.public_cidr_block) : 0
  #count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
}

resource "aws_route_table" "private_rt" {
  count  = var.enable == "true" ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }
  tags = merge({
    Name = format("%s-%s-private-rt", var.app, var.env)
  }, var.tags)
}

resource "aws_route_table_association" "private" {
  count = var.enable == "true" ? length(var.private_cidr_block) : 0
  #count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
}

resource "aws_eip" "nat" {
  count = var.enable == "true" ? 1 : 0
  vpc   = true
  tags = merge({
    Name = format("%s-%s-nat-eip", var.app, var.env)
  }, var.tags)
}

resource "aws_nat_gateway" "this" {
  count         = var.enable == "true" ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge({
    Name = format("%s-%s-nat-public", var.app, var.env)
  }, var.tags)

  depends_on = [aws_internet_gateway.gw]
}

