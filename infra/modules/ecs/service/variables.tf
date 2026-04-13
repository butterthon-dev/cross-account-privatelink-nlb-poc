variable "name_prefix" {
  type        = string
  description = "ECSサービス名の接頭辞"
}

variable "cluster_id" {
  type        = string
  description = "ECSクラスターのID"
}

variable "execution_role_arn" {
  type        = string
  description = "タスク実行ロールのARN"
}

variable "image" {
  type        = string
  description = "コンテナイメージのURL"
}

variable "container_name" {
  type        = string
  description = "コンテナ名"
}

variable "container_port" {
  type        = number
  description = "コンテナのポート番号"
  default     = 8000
}

variable "cpu" {
  type        = number
  description = "タスクのCPUユニット"
  default     = 256
}

variable "memory" {
  type        = number
  description = "タスクのメモリ（MiB）"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "タスクの希望数"
  default     = 1
}

variable "subnet_ids" {
  type        = list(string)
  description = "サブネットIDのリスト"
}

variable "security_group_ids" {
  type        = list(string)
  description = "セキュリティグループIDのリスト"
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch Logsグループ名"
}

variable "region" {
  type        = string
  description = "AWSリージョン"
}
