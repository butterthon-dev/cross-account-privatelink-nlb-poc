variable "listener_arn" {
  description = "リスナーのARN"
  type        = string
}

variable "priority" {
  description = "ルールの優先度 (小さいほど優先)"
  type        = number
}

variable "target_group_arn" {
  description = "forward先のターゲットグループARN"
  type        = string
}

variable "host_headers" {
  description = "Hostヘッダ条件 (いずれかに一致)"
  type        = list(string)
  default     = []
}

variable "path_patterns" {
  description = "パスパターン条件 (いずれかに一致)"
  type        = list(string)
  default     = []
}
