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
      env        = "consumer"
      created_by = "terraform"
    }
  }
}
