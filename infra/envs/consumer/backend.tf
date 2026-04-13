terraform {
  backend "s3" {
    bucket       = "consumer-terraform-state-bucket"
    key          = "consumer.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}
