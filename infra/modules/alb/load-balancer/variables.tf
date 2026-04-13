variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "internal" {
  description = "内部向けALBか"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "ALBをデプロイするサブネットのIDリスト"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALBに付与するセキュリティグループのIDリスト"
  type        = list(string)
}
