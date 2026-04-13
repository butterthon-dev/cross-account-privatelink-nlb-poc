resource "aws_lb_target_group" "this" {
  name        = "${var.name_prefix}-nlb-tg"
  vpc_id      = var.vpc_id
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol

  health_check {
    enabled             = true
    protocol            = var.health_check_protocol
    port                = "traffic-port"
    path                = var.health_check_protocol == "HTTP" || var.health_check_protocol == "HTTPS" ? var.health_check_path : null
    matcher             = var.health_check_protocol == "HTTP" || var.health_check_protocol == "HTTPS" ? var.health_check_matcher : null
    interval            = var.health_check_interval
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}
