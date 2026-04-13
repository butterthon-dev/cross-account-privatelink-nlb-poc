variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "region" {
  description = "リージョン"
  type        = string
}

variable "subnet_ids" {
  description = "サブネットのID"
  type        = list(string)
}

variable "security_group_ids" {
  description = "VPCエンドポイントにアタッチするセキュリティグループID"
  type        = list(string)
}
