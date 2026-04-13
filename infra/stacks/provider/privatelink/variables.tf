variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_ids" {
  description = "NLBをデプロイするサブネットIDリスト (Provider private subnets)"
  type        = list(string)
}

variable "container_port" {
  description = "転送先コンテナのポート"
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "ヘルスチェックパス"
  type        = string
  default     = "/healthz"
}

variable "allowed_account_ids" {
  description = "PrivateLink接続を許可するAWSアカウントIDリスト"
  type        = list(string)
  default     = []
}
