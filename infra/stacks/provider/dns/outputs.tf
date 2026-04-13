output "fqdn" {
  description = "登録したConsumer用サブドメインのFQDN"
  value       = module.consumer_alias.fqdn
}
