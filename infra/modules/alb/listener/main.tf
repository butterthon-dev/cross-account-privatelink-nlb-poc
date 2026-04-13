resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy

  dynamic "default_action" {
    for_each = var.default_action_type == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"
      fixed_response {
        content_type = var.default_fixed_response_content_type
        message_body = var.default_fixed_response_body
        status_code  = var.default_fixed_response_status_code
      }
    }
  }

  dynamic "default_action" {
    for_each = var.default_action_type == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = var.default_forward_target_group_arn
    }
  }

  dynamic "default_action" {
    for_each = var.default_action_type == "redirect" ? [1] : []
    content {
      type = "redirect"
      redirect {
        protocol    = var.default_redirect_protocol
        port        = var.default_redirect_port
        status_code = var.default_redirect_status_code
        host        = var.default_redirect_host
        path        = var.default_redirect_path
      }
    }
  }
}
