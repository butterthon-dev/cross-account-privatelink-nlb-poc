variable "project" {
  type        = string
  description = "プロジェクト名"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "private_subnets" {
  type        = map(string)
  description = "プライベートサブネットのマップ（key: AZ, value: CIDR）"
}

variable "domain" {
  type        = string
  description = "親ドメイン (Hosted Zoneの名前)"
}

variable "consumer_subdomain" {
  type        = string
  description = "Consumer用サブドメイン名"
}

variable "alb_dns_name" {
  type        = string
  description = "ConsumerアカウントのALB DNS名 (Consumer apply後に設定)"
}

variable "alb_zone_id" {
  type        = string
  description = "ConsumerアカウントのALB Hosted Zone ID (Consumer apply後に設定)"
}

variable "cert_validation_records" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Consumer ACM証明書のDNS検証用レコード (Consumer apply後に設定)"
}

variable "consumer_account_ids" {
  type        = list(string)
  description = "PrivateLink接続を許可するConsumerのAWSアカウントIDリスト"
}

variable "service_subdomain" {
  type        = string
  description = "自サービスのサブドメイン名 (NLB TLS用 FQDN = <service_subdomain>.<domain>)"
}

variable "enable_private_dns" {
  type        = bool
  description = "Endpoint Service の Private DNS name を有効化するか。初回はfalse、再apply時にtrueで検証を走らせる"
  default     = false
}
