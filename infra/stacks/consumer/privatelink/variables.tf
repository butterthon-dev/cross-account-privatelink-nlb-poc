variable "name_prefix" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_ids" {
  description = "Interface Endpoint用サブネットIDリスト (Consumer private subnets)"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Consumer ECS用セキュリティグループID (このSGからのingressをEndpointへ許可)"
  type        = string
}

variable "service_port" {
  description = "Provider側サービスのポート (NLB TLSリスナー)"
  type        = number
  default     = 443
}

variable "provider_endpoint_service_name" {
  description = "Provider側 VPC Endpoint Service 名 (com.amazonaws.vpce.<region>.vpce-svc-xxx)"
  type        = string
}

variable "provider_service_fqdn" {
  description = "Provider NLBのACM証明書ドメイン名 (例: provider.example.com)。provider_api_url の組み立てに使用 (名前解決は Endpoint Service の private_dns_name により AWS 管理)"
  type        = string
}
