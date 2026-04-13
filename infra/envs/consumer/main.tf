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
