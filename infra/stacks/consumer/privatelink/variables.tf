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
  description = "Consumer ECS用セキュリティグループID (このSGからの8000をEndpointへ許可)"
  type        = string
}

variable "service_port" {
  description = "Provider側サービスのポート"
  type        = number
  default     = 8000
}

variable "provider_endpoint_service_name" {
  description = "Provider側 VPC Endpoint Service 名 (com.amazonaws.vpce.<region>.vpce-svc-xxx)"
  type        = string
}
