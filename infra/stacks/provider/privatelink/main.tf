data "aws_route53_zone" "parent" {
  name         = var.domain
  private_zone = false
}

locals {
  service_fqdn = "${var.service_subdomain}.${var.domain}"
}

# ACM Certificate (DNS検証) — 自アカウントの public zone で完結

module "certificate" {
  source = "../../../modules/acm/certificate"

  domain_name = local.service_fqdn
}

module "certificate_validation_record" {
  source = "../../../modules/route53/record"

  zone_id = data.aws_route53_zone.parent.zone_id
  name    = module.certificate.domain_validation_options[0].name
  type    = module.certificate.domain_validation_options[0].type
  ttl     = 60
  records = [module.certificate.domain_validation_options[0].value]
}

module "certificate_validation" {
  source = "../../../modules/acm/certificate-validation"

  certificate_arn = module.certificate.arn

  depends_on = [module.certificate_validation_record]
}

# NLB + Target Group + TLS Listener

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
  port              = 443
  protocol          = "TLS"
  certificate_arn   = module.certificate_validation.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  alpn_policy       = "HTTP2Preferred"
  target_group_arn  = module.target_group.arn
}

# VPC Endpoint Service (PrivateLink)
# private_dns_name を指定すると、Consumer 側で private_dns_enabled=true にした VPC Endpoint が
# 自動的に <service_fqdn> を解決できるようになる。
# AWS が生成する TXT 検証レコードを public zone に登録 → verification で検証完了を待機する。

module "endpoint_service" {
  source = "../../../modules/privatelink/endpoint-service"

  name_prefix                = var.name_prefix
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = [module.nlb.arn]
  allowed_principals         = [for id in var.allowed_account_ids : "arn:aws:iam::${id}:root"]
  private_dns_name           = var.enable_private_dns ? local.service_fqdn : null
}

# TXT 検証レコードを public zone に登録 (enable_private_dns=true時のみ)
# private_dns_name_configuration は Endpoint Service に private_dns_name を設定後に
# 初めて populated されるため、初回 apply は enable_private_dns=false で service を更新し、
# 2回目の apply (true) で TXT と検証を走らせる。

module "endpoint_service_dns_verification_record" {
  count = var.enable_private_dns ? 1 : 0

  source = "../../../modules/route53/record"

  zone_id = data.aws_route53_zone.parent.zone_id
  name    = module.endpoint_service.private_dns_name_configuration[0].name
  type    = module.endpoint_service.private_dns_name_configuration[0].type
  ttl     = 60
  records = [module.endpoint_service.private_dns_name_configuration[0].value]
}

# 検証を開始し、AWS が検証完了状態になるまで待機 (enable_private_dns=true時のみ)

module "endpoint_service_dns_verification" {
  count = var.enable_private_dns ? 1 : 0

  source = "../../../modules/privatelink/endpoint-service-private-dns-verification"

  service_id            = module.endpoint_service.id
  wait_for_verification = true

  depends_on = [module.endpoint_service_dns_verification_record]
}
