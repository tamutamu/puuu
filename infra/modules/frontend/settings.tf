locals {
  app_id = "${var.app}-${var.env}"
}

terraform {
  required_version = ">= 1.0.9"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.waf]
    }
  }
}
