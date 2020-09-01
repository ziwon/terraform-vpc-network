variable name {
  type = string
}

variable azs {
  type    = list(string)
  default = []
}

variable cidr {}

variable azs_nat_gateway_count {
  type    = number
  default = 3
}

variable instance_tenancy {
  default = "default"
}

variable map_public_ip_on_launch {
  type    = bool
  default = true
}

variable enable_dns_hostnames {
  type    = bool
  default = false
}

variable enable_dns_support {
  type    = bool
  default = false
}

variable enable_nat_gateway {
  type    = bool
  default = false
}

variable enable_vpn_gateway {
  type    = bool
  default = false
}

variable private_subnets {
  type    = list(string)
  default = []
}

variable public_subnets {
  type    = list(string)
  default = []
}

variable tags {
  type    = map(string)
  default = {}
}
