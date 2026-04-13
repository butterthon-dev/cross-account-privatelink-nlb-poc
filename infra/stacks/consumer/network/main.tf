data "aws_region" "current" {}

module "vpc" {
  source = "../../../modules/network/vpc"

  name_prefix = var.name_prefix
  cidr_block  = var.vpc_cidr_block
}

module "private_subnet" {
  source = "../../../modules/network/subnet"

  for_each = var.private_subnets

  name_prefix       = "${var.name_prefix}-${each.key}-private"
  vpc_id            = module.vpc.id
  cidr_block        = each.value
  availability_zone = each.key
}

# Security Groups

module "vpce_sg" {
  source = "../../../modules/network/security-group"

  name_prefix = "${var.name_prefix}-vpce"
  description = "Security group for VPC endpoints"
  vpc_id      = module.vpc.id
}

module "ecs_sg" {
  source = "../../../modules/network/security-group"

  name_prefix = "${var.name_prefix}-ecs"
  description = "Security group for ECS tasks"
  vpc_id      = module.vpc.id
}

# Security Group Rules

module "vpce_https_ingress" {
  source = "../../../modules/network/security-group-ingress-rule"

  security_group_id = module.vpce_sg.id
  description       = "HTTPS from VPC"
  cidr_ipv4         = module.vpc.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

module "ecs_app_ingress" {
  source = "../../../modules/network/security-group-ingress-rule"

  security_group_id = module.ecs_sg.id
  description       = "App port from VPC"
  cidr_ipv4         = module.vpc.cidr_block
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
}

module "ecs_to_vpce_egress" {
  source = "../../../modules/network/security-group-egress-rule"

  security_group_id = module.ecs_sg.id
  description       = "HTTPS to VPC (interface endpoints)"
  cidr_ipv4         = module.vpc.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

module "ecs_to_s3_egress" {
  source = "../../../modules/network/security-group-egress-rule"

  for_each = module.gateway_vpc_endpoint.prefix_list_ids

  security_group_id = module.ecs_sg.id
  description       = "HTTPS to ${each.key} gateway endpoint"
  prefix_list_id    = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# VPC Endpoints

module "gateway_vpc_endpoint" {
  source = "../../../modules/network/gateway-vpc-endpoint"

  region         = data.aws_region.current.name
  vpc_id         = module.vpc.id
  route_table_id = module.vpc.main_route_table_id
}

module "interface_vpc_endpoint" {
  source = "../../../modules/network/interface-vpc-endpoint"

  region             = data.aws_region.current.name
  vpc_id             = module.vpc.id
  subnet_ids         = [for s in module.private_subnet : s.id]
  security_group_ids = [module.vpce_sg.id]
}
