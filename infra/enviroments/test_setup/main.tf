provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      app_id = local.app_id
    }
  }
}

module "terraform_backend" {
  source        = "../../modules/terraform-state"
  app           = var.app
  env           = var.env
  force_destroy = false
}
