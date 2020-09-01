variable "region" {
  default = "ap-northeast-2"
}

variable "azs" {}

variable "vpc_shared" {
  type = object({
    name            = string
    group_id        = string
    cidr            = string
    public_subnets  = set(string)
    private_subnets = set(string)
    tags            = map(string)
  })
}

variable "vpc_dev" {
  type = object({
    name            = string
    group_id        = string
    cidr            = string
    public_subnets  = set(string)
    private_subnets = set(string)
    tags            = map(string)
  })
}

variable "vpn_in_shared" {
  type = object({
    enable           = bool
    name             = string
    static_routes    = list(string)
    remote_device_ip = string
    tags             = map(string)
  })
}

variable "azs_nat_gateway_count" {
  type    = number
  default = 3
}


variable "tags" {
  type = map(string)
}
