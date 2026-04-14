# consumer env

Consumer 側の Terraform 実行ディレクトリ。

## HTTPS 化の apply 手順

ACM 証明書の DNS 検証レコードを Provider 側の Hosted Zone に作成する必要があり、かつ ALB は `ISSUED` 状態の証明書しか受け付けないため、**段階デプロイ**で進める必要があります。`enable_https` フラグで制御します。

### Phase 1: Consumer を `enable_https = false` で初回 apply

`provider.auto.tfvars` の `enable_https` が `false` であることを確認してから apply。

```bash
terraform apply
```

この時点で作成されるもの:

- VPC / サブネット / IGW / ルートテーブル / SG
- ACM 証明書 (状態: `PENDING_VALIDATION`)
- ALB 本体 + HTTP(80) リスナー（Host ヘッダで ECS へ forward）
- ターゲットグループ + ECS サービス登録

必要情報を取得:

```bash
terraform output alb_dns_name
terraform output alb_zone_id
terraform output -json cert_validation_records
```

### Phase 2: Provider 側の `secrets.auto.tfvars` に上記 3 値を反映して apply

`infra/envs/provider/secrets.auto.tfvars` を編集:

```hcl
domain       = "<parent domain>"
alb_dns_name = "<Phase 1 の alb_dns_name>"
alb_zone_id  = "<Phase 1 の alb_zone_id>"

cert_validation_records = [
  # Phase 1 の cert_validation_records をそのまま貼り付け
  {
    name  = "_xxx.consumer.<domain>."
    type  = "CNAME"
    value = "_yyy.acm-validations.aws."
  }
]
```

Provider 側で apply:

```bash
cd ../provider
terraform apply
```

これで Provider の Hosted Zone に以下が登録される:

- `consumer.<domain>` の A(ALIAS) → Consumer ALB
- 証明書の DNS 検証用 CNAME レコード

### Phase 3: ACM 証明書が `ISSUED` になるのを待つ

DNS 検証は ACM が自動で行います (通常 1〜5 分程度)。

```bash
aws acm list-certificates --region us-west-2 \
  --query 'CertificateSummaryList[?DomainName==`consumer.<domain>`].[DomainName,Status]' \
  --output table
```

`Status` が `ISSUED` になったら次へ。

### Phase 4: Consumer を `enable_https = true` に切替えて再 apply

`infra/envs/consumer/provider.auto.tfvars` を編集:

```hcl
enable_https = true
```

```bash
cd ../consumer
terraform apply
```

作成されるもの:

- `aws_acm_certificate_validation` (即座に完了。証明書は既に ISSUED)
- HTTPS(443) リスナー + Host ヘッダルール
- HTTP(80) リスナーを HTTPS への 301 redirect に変更

### 動作確認

```bash
curl -i https://consumer.<domain>/healthz   # 200
curl -i http://consumer.<domain>/healthz    # 301 → HTTPS
```

## PrivateLink 経由で Provider を呼び出す手順

Provider の ECS を内部公開する NLB + VPC Endpoint Service (PrivateLink) に対し、Consumer 側の Interface VPC Endpoint から接続する構成です。クロスアカウントのため **Provider apply → Consumer apply** の順で実施します。

### Phase A1: Provider の `secrets.auto.tfvars` に Consumer AWS アカウント ID を設定 + 初回 apply

Consumer の AWS アカウント ID を取得:

```bash
# Consumer 側の AWS 認証情報で
aws sts get-caller-identity --query Account --output text
```

`infra/envs/provider/secrets.auto.tfvars` に追記:

```hcl
consumer_account_ids = ["<Consumer の AWSアカウントID>"]
```

`infra/envs/provider/provider.auto.tfvars` の `enable_private_dns` が `false` であることを確認し、Provider を apply:

```bash
cd ../provider
terraform apply
```

作成されるもの:

- NLB (internal) + ターゲットグループ + TLS リスナー (443) + 自アカウントの ACM 証明書 (`<service_subdomain>.<domain>`)
- VPC Endpoint Service (Consumer アカウントを `allowed_principals` に追加、**`private_dns_name` は未設定**)
- Provider ECS サービスが NLB ターゲットグループに登録

### Phase A2: `enable_private_dns = true` に切替えて再 apply (2 段)

`infra/envs/provider/provider.auto.tfvars` を編集:

```hcl
enable_private_dns = true
```

#### Phase A2-a: まず Endpoint Service に private_dns_name を付与 (target 指定)

AWS Provider の性質上、`private_dns_name` を設定しないと `private_dns_name_configuration` 属性は空のままで参照できません。最初に Endpoint Service 単体だけを更新して state をリフレッシュします。

```bash
terraform apply -target=module.privatelink.module.endpoint_service
```

このフェーズで実行されるもの:

- Endpoint Service に `private_dns_name = <service_subdomain>.<domain>` を付与 (状態は `pendingVerification` になる)

#### Phase A2-b: TXT 検証レコード作成 + 検証完了待機

```bash
terraform apply
```

このフェーズで実行されるもの:

- AWS が発行する TXT 所有権検証レコードを Public Hosted Zone に登録
- `aws_vpc_endpoint_service_private_dns_verification` が検証完了まで待機 (通常数分)

検証完了後、`endpoint_service_name` を取得:

```bash
terraform output endpoint_service_name
# → com.amazonaws.vpce.us-west-2.vpce-svc-xxxxxxxxxxxxxxxxx
```

### Phase B: Consumer の `secrets.auto.tfvars` に endpoint service 名を設定

`infra/envs/consumer/secrets.auto.tfvars` に追記:

```hcl
provider_endpoint_service_name = "com.amazonaws.vpce.us-west-2.vpce-svc-xxxxxxxxxxxxxxxxx"
```

Consumer を apply:

```bash
cd ../consumer
terraform apply
```

作成されるもの:

- PrivateLink 用 Interface VPC Endpoint (`private_dns_enabled = true`)
- Endpoint 用 SG (Consumer ECS SG からの 443 ingress)

`private_dns_enabled = true` により、Provider 側 Endpoint Service の `private_dns_name` (例: `provider.example.com`) が Consumer VPC 内で自動的に VPC Endpoint の ENI に解決されます。Consumer 側で Private Hosted Zone を自作する必要はありません。

### Phase C: 動作確認

Consumer の ECS タスクに入って Provider へアクセス:

```bash
# Fargate exec などで consumer コンテナに入ってから
API_URL=$(terraform output -raw provider_api_url)   # 例: https://provider.example.com
curl -i "${API_URL}/healthz"
# → 200 {"message":"healthy from provider."}
```

### GitHub Actions の `PROVIDER_API_URL` 変数

GitHub リポジトリ変数の `PROVIDER_API_URL` には上記 `provider_api_url` output の値 (例: `https://provider.example.com`) を設定してください。設定後に Consumer の ECS を再デプロイすれば、環境変数として注入されます。

