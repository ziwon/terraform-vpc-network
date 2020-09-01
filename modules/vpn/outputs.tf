output "vpn_gw_id" {
  value = aws_vpn_gateway.main.*.id
}

output "customer_gw_id" {
  value = aws_customer_gateway.main.*.id
}

output "aws_vpn_gateway_id" {
  value = aws_vpn_gateway.main.*.id
}

output "customer_gw_ip" {
  value = aws_customer_gateway.main.*.ip_address
}

output "vpn_connection_id" {
  value = aws_vpn_connection.main.*.id
}

output "vpn_connection_tunnel1_address" {
  value = aws_vpn_connection.main.*.tunnel1_address
}

output "vpn_connection_tunnel1_preshared_key" {
  sensitive = true
  value     = aws_vpn_connection.main.*.tunnel1_preshared_key
}

output "vpn_connection_tunnel2_address" {
  value = aws_vpn_connection.main.*.tunnel2_address
}

output "vpn_connection_tunnel2_preshared_key" {
  sensitive = true
  value     = aws_vpn_connection.main.*.tunnel2_preshared_key
}

output "vpn_config" {
  sensitive = true
  value     = aws_vpn_connection.main.*.customer_gateway_configuration
}

output "vpn_connection_static_routes" {
  value = aws_vpn_connection_route.main.*.destination_cidr_block
}
