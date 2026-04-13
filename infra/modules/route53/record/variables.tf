variable "zone_id" {
  description = "Hosted Zone ID"
  type        = string
}

variable "name" {
  description = "レコード名 (FQDN)"
  type        = string
}

variable "type" {
  description = "レコードタイプ (A / AAAA / CNAME / TXT など)"
  type        = string
}

variable "ttl" {
  description = "TTL (ALIAS以外の場合に使用)"
  type        = number
  default     = 300
}

variable "records" {
  description = "レコード値 (ALIAS以外の場合に使用)"
  type        = list(string)
  default     = null
}

variable "alias" {
  description = "ALIAS設定 (ALIASレコードの場合のみ指定)"
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })
  default = null
}
