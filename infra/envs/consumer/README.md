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

### Phase A: Provider の `secrets.auto.tfvars` に Consumer AWS アカウント ID を設定

Consumer の AWS アカウント ID を取得:

```bash
# Consumer 側の AWS 認証情報で
aws sts get-caller-identity --query Account --output text
```

`infra/envs/provider/secrets.auto.tfvars` に追記:

```hcl
consumer_account_ids = ["<Consumer の AWSアカウントID>"]
```

Provider を apply:

```bash
cd ../provider
terraform apply
```

作成されるもの:

- NLB (internal) + ターゲットグループ + リスナー (TCP 8000)
- VPC Endpoint Service (Consumer アカウントを `allowed_principals` に追加、自動承認)
- Provider ECS サービスが NLB ターゲットグループに登録

`endpoint_service_name` を取得:

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

- PrivateLink 用 Interface VPC Endpoint (private DNS 無効)
- Endpoint 用 SG (Consumer ECS SG からの 8000 ingress)
- Consumer ECS SG に 8000 egress (VPC CIDR 宛) を追加

`provider_endpoint_dns_name` を取得:

```bash
terraform output provider_endpoint_dns_name
# → vpce-xxxxxxxx-yyyyyyyy.vpce-svc-zzzz.us-west-2.vpce.amazonaws.com
```

### Phase C: 動作確認

Consumer の ECS タスクに入って Provider へアクセス:

```bash
# Fargate exec などで consumer コンテナに入ってから
curl -i "http://<provider_endpoint_dns_name>:8000/healthz"
# → 200 {"message":"healthy from provider."}
```

Consumer アプリに `PROVIDER_API_URL=http://<provider_endpoint_dns_name>:8000` を環境変数として渡せば、HTTPS の Consumer 公開エンドポイント越しに Provider API を呼び出すフルフローが動作します。

