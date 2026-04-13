module "network" {
  source = "../../stacks/consumer/network"

  name_prefix     = var.project
  vpc_cidr_block  = var.vpc_cidr_block
  private_subnets = var.private_subnets
}

module "ecs" {
  source = "../../stacks/consumer/ecs"

  name_prefix           = var.project
  subnet_ids            = module.network.private_subnet_ids
  ecs_security_group_id = module.network.ecs_security_group_id
}
