module "network" {
  source = "../../stacks/provider/network"

  name_prefix     = var.project
  vpc_cidr_block  = var.vpc_cidr_block
  private_subnets = var.private_subnets
}

module "privatelink" {
  source = "../../stacks/provider/privatelink"

  name_prefix         = var.project
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  allowed_account_ids = var.consumer_account_ids
}

module "ecs" {
  source = "../../stacks/provider/ecs"

  name_prefix           = var.project
  subnet_ids            = module.network.private_subnet_ids
  ecs_security_group_id = module.network.ecs_security_group_id
  target_group_arn      = module.privatelink.target_group_arn
}

module "dns" {
  source = "../../stacks/provider/dns"

  domain                           = var.domain
  consumer_subdomain               = var.consumer_subdomain
  consumer_alb_dns_name            = var.alb_dns_name
  consumer_alb_zone_id             = var.alb_zone_id
  consumer_cert_validation_records = var.cert_validation_records
}

output "consumer_fqdn" {
  description = "Consumer公開用FQDN"
  value       = module.dns.fqdn
}

output "endpoint_service_name" {
  description = "VPC Endpoint Service 名 (Consumer側で secrets.auto.tfvars に設定)"
  value       = module.privatelink.endpoint_service_name
}
