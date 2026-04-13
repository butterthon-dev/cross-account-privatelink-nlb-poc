# infra/setup

Terraform を実行するための前提リソースを CloudFormation で作成します。
（ProviderとConsumerそれぞれのAWSアカウントで実行する）

## 作成されるリソース

| リソース | 説明 |
|---|---|
| S3 バケット | Terraform state ファイルの保存先（バージョニング・暗号化有効） |
| OIDC Provider | GitHub Actions 用の ID プロバイダー |
| IAM Role (`<Prefix>-github-actions-oidc-role`) | GitHub Actions が AssumeRole するためのロール（AdministratorAccess） |

## パラメータ

| パラメータ | 説明 |
|---|---|
| `GitHubOrg` | GitHub のオーナー名（organization or user） |
| `GitHubRepo` | GitHub のリポジトリ名 |
| `Prefix` | リソース名の接頭辞（デフォルト: `xapl`） |

## デプロイ

```bash
aws cloudformation deploy \
  --template-file cloud-formation.yaml \
  --stack-name xapl-setup \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    GitHubOrg=<your-org> \
    GitHubRepo=<your-repo> \
    NamePrefix=<provider or consumer>
```
