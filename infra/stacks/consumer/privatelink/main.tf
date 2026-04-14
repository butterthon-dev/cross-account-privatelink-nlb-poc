module "endpoint_sg" {
  source = "../../../modules/network/security-group"

  name_prefix = "${var.name_prefix}-privatelink"
  description = "Security group for PrivateLink VPC Endpoint (provider API)"
  vpc_id      = var.vpc_id
}

module "endpoint_ingress_from_ecs" {
  source = "../../../modules/network/security-group-ingress-rule"

  security_group_id            = module.endpoint_sg.id
  description                  = "Provider API TLS port from ECS"
  referenced_security_group_id = var.ecs_security_group_id
  from_port                    = var.service_port
  to_port                      = var.service_port
  ip_protocol                  = "tcp"
}

# private_dns_enabled=true により、Provider 側 Endpoint Service の private_dns_name
# (例: provider.example.com) がこの VPC Endpoint の ENI へ AWS 管理で自動解決される。
# Consumer 側で Private Hosted Zone を自前で作る必要はない。
module "endpoint" {
  source = "../../../modules/network/vpc-endpoint"

  name_prefix         = "${var.name_prefix}-privatelink"
  vpc_id              = var.vpc_id
  service_name        = var.provider_endpoint_service_name
  type                = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [module.endpoint_sg.id]
  private_dns_enabled = true
}
