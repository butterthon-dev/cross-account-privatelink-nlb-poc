module "alb" {
  source = "../../../modules/alb/load-balancer"

  name_prefix        = var.name_prefix
  internal           = false
  subnet_ids         = var.public_subnet_ids
  security_group_ids = [var.alb_security_group_id]
}

module "target_group" {
  source = "../../../modules/alb/target-group"

  name_prefix       = var.name_prefix
  vpc_id            = var.vpc_id
  target_type       = "ip"
  port              = var.container_port
  protocol          = "HTTP"
  health_check_path = var.health_check_path
}

# ACM Certificate (DNS検証)

module "certificate" {
  source = "../../../modules/acm/certificate"

  domain_name = var.allowed_host_header
}

# Certificate Validation (cert が ISSUED になるまで待機)
# 初回apply時はenable_https=falseでスキップし、Provider側で検証レコード登録後にtrue化して再apply

module "certificate_validation" {
  count = var.enable_https ? 1 : 0

  source = "../../../modules/acm/certificate-validation"

  certificate_arn = module.certificate.arn
}

# HTTP listener (80)
# - enable_https=false: Hostヘッダ一致で ECS へ forward、一致しなければ 403
# - enable_https=true : HTTPS (443) へ redirect

module "http_listener" {
  source = "../../../modules/alb/listener"

  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action_type = var.enable_https ? "redirect" : "fixed-response"

  default_redirect_protocol    = "HTTPS"
  default_redirect_port        = "443"
  default_redirect_status_code = "HTTP_301"

  default_fixed_response_status_code = "403"
  default_fixed_response_body        = "Forbidden"
}

module "http_host_header_rule" {
  count = var.enable_https ? 0 : 1

  source = "../../../modules/alb/listener-rule"

  listener_arn     = module.http_listener.arn
  priority         = 1
  target_group_arn = module.target_group.arn
  host_headers     = [var.allowed_host_header]
}

# HTTPS listener (443) — enable_https=true時のみ作成

module "https_listener" {
  count = var.enable_https ? 1 : 0

  source = "../../../modules/alb/listener"

  load_balancer_arn = module.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = module.certificate_validation[0].certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action_type                = "fixed-response"
  default_fixed_response_status_code = "403"
  default_fixed_response_body        = "Forbidden"
}

module "https_host_header_rule" {
  count = var.enable_https ? 1 : 0

  source = "../../../modules/alb/listener-rule"

  listener_arn     = module.https_listener[0].arn
  priority         = 1
  target_group_arn = module.target_group.arn
  host_headers     = [var.allowed_host_header]
}
