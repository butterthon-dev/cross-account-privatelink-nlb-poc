variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "public_subnet_ids" {
  description = "ALBをデプロイするパブリックサブネットID"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB用セキュリティグループID"
  type        = string
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

variable "allowed_host_header" {
  description = "許可するHostヘッダ (これ以外は403)"
  type        = string
}

variable "enable_https" {
  description = <<-EOT
    HTTPSリスナーとHTTP→HTTPSリダイレクトを有効化するか。
    初回apply時は false にして証明書のみ作成し、
    Provider側で検証レコードを登録して証明書がISSUEDになってから true にして再apply する。
  EOT
  type        = bool
  default     = false
}
