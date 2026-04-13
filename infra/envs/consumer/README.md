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
