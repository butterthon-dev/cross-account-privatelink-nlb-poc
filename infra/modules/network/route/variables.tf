variable "route_table_id" {
  description = "ルートテーブルのID"
  type        = string
}

# 宛先 (いずれか1つを指定)

variable "destination_cidr_block" {
  description = "宛先 CIDR (IPv4)"
  type        = string
  default     = null
}

variable "destination_ipv6_cidr_block" {
  description = "宛先 CIDR (IPv6)"
  type        = string
  default     = null
}

variable "destination_prefix_list_id" {
  description = "宛先プレフィックスリストID"
  type        = string
  default     = null
}

# ターゲット (いずれか1つを指定)

variable "gateway_id" {
  description = "Internet Gateway / Virtual Private Gateway の ID"
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "NAT Gateway の ID"
  type        = string
  default     = null
}

variable "vpc_endpoint_id" {
  description = "VPC Endpoint の ID"
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "ENI の ID"
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "Transit Gateway の ID"
  type        = string
  default     = null
}
