variable "name_prefix" {
  type        = string
  description = "リソース名の接頭辞"
}

variable "subnet_ids" {
  type        = list(string)
  description = "サブネットIDのリスト"
}

variable "ecs_security_group_id" {
  type        = string
  description = "ECS用セキュリティグループのID"
}

variable "target_group_arn" {
  type        = string
  description = "ALBのターゲットグループARN (未指定時はLBに登録しない)"
  default     = null
}
