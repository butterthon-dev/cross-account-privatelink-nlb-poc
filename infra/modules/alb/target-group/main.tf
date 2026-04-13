resource "aws_lb_target_group" "this" {
  name        = "${var.name_prefix}-tg"
  vpc_id      = var.vpc_id
  target_type = var.target_type
  port        = var.port
  protocol    = var.protocol

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.protocol
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}
