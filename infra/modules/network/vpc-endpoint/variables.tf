variable "name_prefix" {
  type        = string
  description = "VPCエンドポイント名の接頭辞"
}

variable "vpc_id" {
  type        = string
  description = "VPCのID"
}

variable "service_name" {
  type        = string
  description = "VPCエンドポイントのサービス名"
}

variable "type" {
  type        = string
  description = "VPCエンドポイントのタイプ（Interface or Gateway）"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Interfaceエンドポイント用のサブネットID"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "Interfaceエンドポイント用のセキュリティグループID"
  default     = []
}

variable "route_table_ids" {
  type        = list(string)
  description = "Gatewayエンドポイント用のルートテーブルID"
  default     = []
}

variable "private_dns_enabled" {
  type        = bool
  description = "プライベートDNSを有効化するか (Interface用)"
  default     = true
}
