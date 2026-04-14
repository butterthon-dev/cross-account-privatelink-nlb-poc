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

variable "acceptance_required" {
  description = "接続リクエストに手動承認を要求するか"
  type        = bool
  default     = true
}

variable "domain" {
  description = "親ドメイン (Hosted Zoneの名前)"
  type        = string
}

variable "service_subdomain" {
  description = "自サービスのサブドメイン名 (例: provider)"
  type        = string
}

variable "enable_private_dns" {
  description = <<-EOT
    Endpoint Service の Private DNS name 機能を有効化するか。
    初回 apply: false で Endpoint Service を作成 (private_dns_name 未設定)。
    次回 apply: true で private_dns_name を付与し、TXT 所有権検証レコード作成 + 検証完了を待機。
  EOT
  type        = bool
  default     = false
}
