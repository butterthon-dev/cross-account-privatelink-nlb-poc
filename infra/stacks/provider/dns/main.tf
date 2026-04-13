data "aws_route53_zone" "parent" {
  name         = var.domain
  private_zone = false
}

# Consumer用サブドメイン (ALBへのALIAS)

module "consumer_alias" {
  source = "../../../modules/route53/record"

  zone_id = data.aws_route53_zone.parent.zone_id
  name    = "${var.consumer_subdomain}.${var.domain}"
  type    = "A"

  alias = {
    name                   = var.consumer_alb_dns_name
    zone_id                = var.consumer_alb_zone_id
    evaluate_target_health = false
  }
}

# Consumer ACM証明書 DNS検証用レコード

module "consumer_cert_validation" {
  source = "../../../modules/route53/record"

  for_each = {
    for r in var.consumer_cert_validation_records : r.name => r
  }

  zone_id = data.aws_route53_zone.parent.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}
