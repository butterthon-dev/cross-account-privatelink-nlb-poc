resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  dynamic "condition" {
    for_each = length(var.host_headers) > 0 ? [1] : []
    content {
      host_header {
        values = var.host_headers
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.path_patterns) > 0 ? [1] : []
    content {
      path_pattern {
        values = var.path_patterns
      }
    }
  }
}
