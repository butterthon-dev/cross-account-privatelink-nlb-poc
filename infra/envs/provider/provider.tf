terraform {
  required_version = ">= 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      env        = "provider"
      created_by = "terraform"
    }
  }
}
