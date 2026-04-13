module "nlb" {
  source = "../../../modules/nlb/load-balancer"

  name_prefix = var.name_prefix
  internal    = true
  subnet_ids  = var.subnet_ids
}

module "target_group" {
  source = "../../../modules/nlb/target-group"

  name_prefix           = var.name_prefix
  vpc_id                = var.vpc_id
  target_type           = "ip"
  port                  = var.container_port
  protocol              = "TCP"
  health_check_protocol = "HTTP"
  health_check_path     = var.health_check_path
}

module "listener" {
  source = "../../../modules/nlb/listener"

  load_balancer_arn = module.nlb.arn
  port              = var.container_port
  protocol          = "TCP"
  target_group_arn  = module.target_group.arn
}

module "endpoint_service" {
  source = "../../../modules/privatelink/endpoint-service"

  name_prefix                = var.name_prefix
  acceptance_required        = false
  network_load_balancer_arns = [module.nlb.arn]
  allowed_principals         = [for id in var.allowed_account_ids : "arn:aws:iam::${id}:root"]
}
