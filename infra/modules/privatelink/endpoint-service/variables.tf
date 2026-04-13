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
