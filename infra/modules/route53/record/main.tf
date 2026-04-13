resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.name
  type    = var.type

  # 通常レコード (ALIAS以外)
  ttl     = var.alias == null ? var.ttl : null
  records = var.alias == null ? var.records : null

  # ALIASレコード
  dynamic "alias" {
    for_each = var.alias == null ? [] : [var.alias]
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
