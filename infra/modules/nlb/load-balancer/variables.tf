variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "internal" {
  description = "内部向けNLBか"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "NLBをデプロイするサブネットのIDリスト"
  type        = list(string)
}
