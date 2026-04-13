project        = "provider"
vpc_cidr_block = "10.0.0.0/16" # VPCのCIDRが重複してても問題かも確認するため、providerとconsumerで同じCIDRを設定する
private_subnets = {
  "us-west-2a" = "10.0.1.0/24"
  "us-west-2c" = "10.0.2.0/24"
}
