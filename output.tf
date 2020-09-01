output "vpc_shared_id" {
  value = data.aws_vpc.shared.id
}

output "vpc_shared_route_table_ids" {
  value = data.aws_route_tables.shared.ids
}

output "vpc_shared_route_table_public_id" {
  value = module.vpc_shared.route_table_public
}

output "vpc_shared_route_table_private_ids" {
  value = module.vpc_shared.route_tables_private
}

output "vpc_dev_id" {
  value = data.aws_vpc.dev.id
}

output "vpc_dev_route_table_ids" {
  value = data.aws_route_tables.dev.ids
}

output "vpc_dev_route_table_public_id" {
  value = module.vpc_dev.route_table_public
}

output "vpc_dev_route_table_private_ids" {
  value = module.vpc_dev.route_tables_private
}

output "vpn_gw_id" {
  value = module.vpn_in_shared.vpn_gw_id
}

output "customer_gw_id" {
  value = module.vpn_in_shared.customer_gw_id
}

output "aws_vpn_gateway_id" {
  value = module.vpn_in_shared.aws_vpn_gateway_id
}

output "customer_gw_ip" {
  value = module.vpn_in_shared.customer_gw_id
}

output "vpn_connection_tunnel1_address" {
  value = module.vpn_in_shared.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel1_preshared_key" {
  value = module.vpn_in_shared.vpn_connection_tunnel1_preshared_key
}

output "vpn_connection_tunnel2_address" {
  value = module.vpn_in_shared.vpn_connection_tunnel2_address
}

output "vpn_connection_tunnel2_preshared_key" {
  value = module.vpn_in_shared.vpn_connection_tunnel2_preshared_key
}
