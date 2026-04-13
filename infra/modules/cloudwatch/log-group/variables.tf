variable "name_prefix" {
  type        = string
  description = "ロググループ名の接頭辞"
}

variable "retention_in_days" {
  type        = number
  description = "ログの保持日数"
  default     = 7
}
