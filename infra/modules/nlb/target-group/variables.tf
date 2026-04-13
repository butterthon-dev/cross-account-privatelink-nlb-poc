variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "target_type" {
  description = "ターゲットタイプ (ip / instance)"
  type        = string
  default     = "ip"
}

variable "port" {
  description = "ターゲットポート"
  type        = number
}

variable "protocol" {
  description = "プロトコル (TCP / UDP / TCP_UDP / TLS)"
  type        = string
  default     = "TCP"
}

variable "health_check_protocol" {
  description = "ヘルスチェックプロトコル (TCP / HTTP / HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "ヘルスチェックパス (HTTP/HTTPSのみ)"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "ヘルスチェック成功HTTPコード (HTTP/HTTPSのみ)"
  type        = string
  default     = "200"
}

variable "health_check_interval" {
  description = "ヘルスチェック間隔(秒)"
  type        = number
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "正常判定閾値"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "異常判定閾値"
  type        = number
  default     = 3
}
