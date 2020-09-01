provider "aws" {
  alias  = "src"
  region = var.region
}

provider "aws" {
  alias  = "dst"
  region = var.region
}

variable "region" {
  type = string
}

variable "peer_src_vpc_id" {
  type = string
}

variable "peer_src_route_tables" {
  type    = list
  default = []
}

variable "peer_dst_vpc_id" {
  type = string
}

variable "peer_dst_route_tables" {
  type    = list
  default = []
}

variable "auto_accept" {
  type    = string
  default = true
}

variable "tag_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

data "aws_vpc" "peer_src_vpc" {
  provider = aws.src
  id       = var.peer_src_vpc_id
}

data "aws_vpc" "peer_dst_vpc" {
  provider = aws.dst
  id       = var.peer_dst_vpc_id
}

data "aws_region" "dst_vpc" {
  provider = aws.dst
}

resource "aws_route" "peer_src_to_peer_dst" {
  provider = aws.src
  count    = length(var.peer_src_route_tables)

  route_table_id            = element(var.peer_src_route_tables, count.index)
  destination_cidr_block    = data.aws_vpc.peer_dst_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

resource "aws_route" "peer_dst_to_peer_src" {
  provider = aws.dst
  count    = length(var.peer_dst_route_tables)

  route_table_id            = element(var.peer_dst_route_tables, count.index)
  destination_cidr_block    = data.aws_vpc.peer_src_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

resource "aws_vpc_peering_connection" "default" {
  provider    = aws.src
  peer_vpc_id = data.aws_vpc.peer_dst_vpc.id
  vpc_id      = data.aws_vpc.peer_src_vpc.id

  auto_accept = var.auto_accept

  tags = merge(
    {
      "Name" = var.tag_name
    },
    var.tags
  )
}

output "peering_connection_id" {
  value = aws_vpc_peering_connection.default.id
}
