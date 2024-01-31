locals {
  app_id = "${var.app}-${var.env}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
  required_version = "~> 1.1"

  backend "s3" {
    bucket         = "aichatfuu-test-terraform-backend"
    key            = "aichatfuu"
    encrypt        = true
    dynamodb_table = "aichatfuu-test_terraform_tfstate_lock"
    region         = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      app_id = local.app_id
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"

  default_tags {
    tags = {
      app_id = local.app_id
    }
  }
}
