variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "acceptance_required" {
  description = "接続リクエストに手動承認を要求するか"
  type        = bool
  default     = false
}

variable "network_load_balancer_arns" {
  description = "紐付けるNLBのARNリスト"
  type        = list(string)
}

variable "allowed_principals" {
  description = "接続を許可するIAM Principal ARNリスト (例: arn:aws:iam::123456789012:root)"
  type        = list(string)
  default     = []
}

variable "private_dns_name" {
  description = "Endpoint Service に紐付ける Private DNS name (例: provider.example.com)。Consumer側で private_dns_enabled=true を使うと自動解決される。指定時はドメイン所有権の TXT 検証が必要"
  type        = string
  default     = null
}
