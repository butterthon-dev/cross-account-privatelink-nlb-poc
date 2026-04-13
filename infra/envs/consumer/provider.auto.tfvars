project        = "consumer"
vpc_cidr_block = "10.0.0.0/16" # VPCのCIDRが重複してても問題かも確認するため、providerとconsumerで同じCIDRを設定する
private_subnets = {
  "us-west-2a" = "10.0.1.0/24"
  "us-west-2c" = "10.0.2.0/24"
}
public_subnets = {
  "us-west-2a" = "10.0.101.0/24"
  "us-west-2c" = "10.0.102.0/24"
}

# DNS
# domain は secrets.auto.tfvars で設定
subdomain = "consumer"

# HTTPS化フラグ
# 初回: false で証明書+ALB(HTTPのみ)を作成
# Providerで検証レコードを登録し証明書がISSUEDになったら: true でHTTPSリスナーを作成
enable_https = true
