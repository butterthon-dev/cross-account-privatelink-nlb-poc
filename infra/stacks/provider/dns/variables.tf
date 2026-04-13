variable "domain" {
  description = "親ドメイン (Hosted Zoneの名前)"
  type        = string
}

variable "consumer_subdomain" {
  description = "Consumer用サブドメイン名 (例: consumer)"
  type        = string
}

variable "consumer_alb_dns_name" {
  description = "ConsumerアカウントのALB DNS名"
  type        = string
}

variable "consumer_alb_zone_id" {
  description = "ConsumerアカウントのALB Hosted Zone ID"
  type        = string
}

variable "consumer_cert_validation_records" {
  description = "Consumer ACM証明書のDNS検証用レコード"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}
