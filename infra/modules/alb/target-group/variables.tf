variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "target_type" {
  description = "ターゲットタイプ (ip / instance / lambda / alb)"
  type        = string
  default     = "ip"
}

variable "port" {
  description = "ターゲットポート"
  type        = number
}

variable "protocol" {
  description = "プロトコル (HTTP / HTTPS など)"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "ヘルスチェックパス"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "ヘルスチェック成功HTTPコード"
  type        = string
  default     = "200"
}

variable "health_check_interval" {
  description = "ヘルスチェック間隔(秒)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "ヘルスチェックタイムアウト(秒)"
  type        = number
  default     = 5
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
