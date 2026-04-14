variable "load_balancer_arn" {
  description = "NLBのARN"
  type        = string
}

variable "port" {
  description = "リスナーのポート"
  type        = number
}

variable "protocol" {
  description = "プロトコル (TCP / UDP / TCP_UDP / TLS)"
  type        = string
  default     = "TCP"
}

variable "target_group_arn" {
  description = "forward先ターゲットグループのARN"
  type        = string
}

variable "certificate_arn" {
  description = "ACM証明書のARN (TLSリスナー時のみ)"
  type        = string
  default     = null
}

variable "alpn_policy" {
  description = "ALPNポリシー (TLSリスナー時)"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSLポリシー (TLSリスナー時)"
  type        = string
  default     = null
}
