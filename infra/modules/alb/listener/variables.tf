variable "load_balancer_arn" {
  description = "ALBのARN"
  type        = string
}

variable "port" {
  description = "リスナーのポート"
  type        = number
}

variable "protocol" {
  description = "プロトコル (HTTP / HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ACM証明書のARN (HTTPSの場合のみ)"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSLポリシー (HTTPSの場合のみ)"
  type        = string
  default     = null
}

# Default action

variable "default_action_type" {
  description = "デフォルトアクション種別 (fixed-response / forward / redirect)"
  type        = string

  validation {
    condition     = contains(["fixed-response", "forward", "redirect"], var.default_action_type)
    error_message = "default_action_type must be one of fixed-response / forward / redirect"
  }
}

# fixed-response 用

variable "default_fixed_response_status_code" {
  description = "fixed-response のステータスコード"
  type        = string
  default     = "403"
}

variable "default_fixed_response_content_type" {
  description = "fixed-response の Content-Type"
  type        = string
  default     = "text/plain"
}

variable "default_fixed_response_body" {
  description = "fixed-response の body"
  type        = string
  default     = "Forbidden"
}

# forward 用

variable "default_forward_target_group_arn" {
  description = "forward 時のターゲットグループARN"
  type        = string
  default     = null
}

# redirect 用

variable "default_redirect_protocol" {
  description = "redirect 先プロトコル"
  type        = string
  default     = "HTTPS"
}

variable "default_redirect_port" {
  description = "redirect 先ポート"
  type        = string
  default     = "443"
}

variable "default_redirect_status_code" {
  description = "redirect のステータスコード"
  type        = string
  default     = "HTTP_301"
}

variable "default_redirect_host" {
  description = "redirect 先ホスト"
  type        = string
  default     = "#{host}"
}

variable "default_redirect_path" {
  description = "redirect 先パス"
  type        = string
  default     = "/#{path}"
}
