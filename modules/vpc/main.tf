locals {
  nat_gateway_count = var.azs_nat_gateway_count
  vpc_id            = aws_vpc.this.id
  nat_gateway_ips   = aws_eip.nat.*.id
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    map("Name", format("%s", var.name)),
    var.tags
  )
}

#################################################################################
# Public Network
#################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id

  tags = merge(
    map("Name", format("%s", var.name)),
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    map("Name", format("%s-public", var.name)),
    map("Type", "public"),
    var.tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count
  vpc   = true

  tags = merge(
    map("Name", format("%s", var.name)),
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = element(local.nat_gateway_ips, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  depends_on = [aws_internet_gateway.this]

  tags = merge(
    map("Name", format("%s-%s", var.name, element(var.azs, count.index))),
    var.tags
  )
}

#################################################################################
# Private Network
#################################################################################

resource "aws_route_table" "private" {
  count = local.nat_gateway_count

  vpc_id = local.vpc_id

  tags = merge(
    map("Name", format("%s-private", var.name)),
    map("Type", "private"),
    var.tags
  )
}

resource "aws_route" "private_nat_gateway" {
  count = local.nat_gateway_count

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

#################################################################################
# Subnet Setup
#################################################################################
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = local.vpc_id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    map("Name", format("%s-public-%s", var.name, var.azs[count.index])),
    map("Type", "public"),
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = local.vpc_id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    map("Name", format("%s-private-%s", var.name, var.azs[count.index])),
    map("Type", "private"),
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_default_security_group" "this" {
  vpc_id = local.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    map("Name", format("%s", var.name)),
    var.tags
  )
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)

  tags = merge(
    map("Name", format("%s", var.name)),
    var.tags
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}
