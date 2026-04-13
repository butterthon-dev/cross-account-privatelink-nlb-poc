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
