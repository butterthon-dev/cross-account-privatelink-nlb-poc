terraform {
  backend "s3" {
    bucket       = "provider-terraform-state-bucket"
    key          = "provider.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}
