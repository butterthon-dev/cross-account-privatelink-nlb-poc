resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  certificate_arn   = var.certificate_arn
  alpn_policy       = var.alpn_policy
  ssl_policy        = var.ssl_policy

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}
