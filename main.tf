module "global" {
  source = "./modules/global"
  name   = "main-infra-${var.region}"
}

module "vpc_shared" {
  source = "./modules/vpc"
  azs    = var.azs
  name   = var.vpc_shared.name
  cidr   = var.vpc_shared.cidr

  private_subnets = var.vpc_shared.private_subnets
  public_subnets  = var.vpc_shared.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  azs_nat_gateway_count = var.azs_nat_gateway_count

  tags = merge(
    var.vpc_shared.tags,
    var.tags
  )
}

module "vpc_dev" {
  source = "./modules/vpc"
  azs    = var.azs
  name   = var.vpc_dev.name
  cidr   = var.vpc_dev.cidr

  private_subnets = var.vpc_dev.private_subnets
  public_subnets  = var.vpc_dev.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  azs_nat_gateway_count = var.azs_nat_gateway_count

  tags = merge(
    var.vpc_dev.tags,
    var.tags
  )
}

#################################################################################
# Due to dependency issues between modules, you can create vpc-peering after
# creating vpc. See details (https://github.com/hashicorp/terraform/issues/14432)
#
# Please keep the order with vpc-peering modules:
# > make plan-vpc dev && make apply-vpc dev
# > make plan dev && make apply dev
################################################################################
module "vpc_peering_shared_to_dev" {
  source = "./modules/vpc_peering"
  region = var.region

  peer_src_vpc_id = data.aws_vpc.shared.id
  peer_dst_vpc_id = data.aws_vpc.dev.id

  peer_src_route_tables = data.aws_route_tables.shared.ids
  peer_dst_route_tables = data.aws_route_tables.dev.ids

  auto_accept = true
  tag_name    = format("%s-to-dev", "shared")
  tags = merge(
    var.tags
  )
}

module "vpn_in_shared" {
  source           = "./modules/vpn"
  enable           = var.vpn_in_shared.enable
  name             = var.vpn_in_shared.name
  vpc_id           = module.vpc_shared.vpc_id
  static_routes    = var.vpn_in_shared.static_routes
  remote_device_ip = var.vpn_in_shared.remote_device_ip

  # for route propagation
  rtb_public_id   = module.vpc_shared.route_table_public
  rtb_private_ids = module.vpc_shared.route_tables_private

  tags = merge(
    var.vpn_in_shared.tags,
    var.tags
  )
}

