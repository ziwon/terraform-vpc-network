resource "aws_vpn_gateway" "main" {
  count = var.enable == true ? 1 : 0

  vpc_id = var.vpc_id
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}


resource "aws_customer_gateway" "main" {
  count = var.enable == true ? 1 : 0

  ip_address = var.remote_device_ip
  bgp_asn    = var.bgp_asn
  type       = "ipsec.1"
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}


resource "aws_vpn_connection" "main" {
  count = var.enable == true ? 1 : 0

  vpn_gateway_id      = aws_vpn_gateway.main[count.index].id
  customer_gateway_id = aws_customer_gateway.main[count.index].id
  type                = var.connection_type
  static_routes_only  = var.static_routes_only
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [type]
  }
}


resource "aws_vpn_connection_route" "main" {
  count = var.enable == true ? length(var.static_routes) : 0

  destination_cidr_block = element(var.static_routes, count.index)
  vpn_connection_id      = aws_vpn_connection.main[count.index].id
}


resource "aws_vpn_gateway_route_propagation" "public_propagation" {
  count = var.enable == true ? 1 : 0

  vpn_gateway_id = aws_vpn_gateway.main[0].id
  route_table_id = var.rtb_public_id
}

resource "aws_vpn_gateway_route_propagation" "private_propagation" {
  count = var.enable == true ? length(var.rtb_private_ids) : 0

  vpn_gateway_id = aws_vpn_gateway.main[0].id
  route_table_id = var.rtb_private_ids[count.index]
}
