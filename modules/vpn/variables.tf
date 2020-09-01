variable "enable" {
  type    = bool
  default = false
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "remote_device_ip" {
  type = string
}

variable "bgp_asn" {
  type    = string
  default = "65000"
}

variable "connection_type" {
  type    = string
  default = "ipsec.1"
}

variable "static_routes_only" {
  type    = bool
  default = true
}

variable "static_routes" {
  type    = list(string)
  default = []
}

variable "rtb_public_id" {
  type = string
}

variable "rtb_private_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
