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

variable "public_subnets" {
  type        = map(string)
  description = "パブリックサブネットのマップ（key: AZ, value: CIDR）"
}

variable "domain" {
  type        = string
  description = "親ドメイン (Hosted Zoneの名前)"
}

variable "subdomain" {
  type        = string
  description = "自サービスのサブドメイン名"
}

variable "enable_https" {
  type        = bool
  description = "HTTPSリスナーを有効化するか。初回はfalse、Providerで検証レコード登録後にtrueへ"
}

variable "provider_endpoint_service_name" {
  type        = string
  description = "Provider側 VPC Endpoint Service 名 (Provider apply後に設定)"
}

variable "provider_service_subdomain" {
  type        = string
  description = "Provider側サービスのサブドメイン (NLB TLS証明書ドメインの <subdomain>.<domain>)"
}
