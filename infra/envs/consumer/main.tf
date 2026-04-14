module "network" {
  source = "../../stacks/consumer/network"

  name_prefix     = var.project
  vpc_cidr_block  = var.vpc_cidr_block
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "alb" {
  source = "../../stacks/consumer/alb"

  name_prefix           = var.project
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id
  allowed_host_header   = "${var.subdomain}.${var.domain}"
  enable_https          = var.enable_https
}

module "privatelink" {
  source = "../../stacks/consumer/privatelink"

  name_prefix                    = var.project
  vpc_id                         = module.network.vpc_id
  subnet_ids                     = module.network.private_subnet_ids
  ecs_security_group_id          = module.network.ecs_security_group_id
  provider_endpoint_service_name = var.provider_endpoint_service_name
  provider_service_fqdn          = "${var.provider_service_subdomain}.${var.domain}"
}

module "ecs" {
  source = "../../stacks/consumer/ecs"

  name_prefix           = var.project
  subnet_ids            = module.network.private_subnet_ids
  ecs_security_group_id = module.network.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
}

output "alb_dns_name" {
  description = "ALBのDNS名 (Provider側のRoute53レコードに設定)"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALBのHosted Zone ID (Provider側のRoute53レコードに設定)"
  value       = module.alb.alb_zone_id
}

output "cert_validation_records" {
  description = "ACM DNS検証レコード (Provider側のHosted Zoneに登録する)"
  value       = module.alb.certificate_validation_records
}

output "provider_endpoint_dns_name" {
  description = "Provider API呼び出し用 PrivateLink endpoint DNS名 (VPC Endpoint の生DNS)"
  value       = module.privatelink.endpoint_dns_name
}

output "provider_api_url" {
  description = "Provider API 呼び出し用URL (TLS対応、Endpoint Service Private DNS による自動解決)"
  value       = module.privatelink.provider_api_url
}
