locals {
  bucket_name = join("-", [var.app, var.env, "terraform", "backend"])
}

# Terraform の tfstate を配置するための S3 Bucket
resource "aws_s3_bucket" "tfstate" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name = local.bucket_name
  }
}

# tfstate はバージョニングを行うことが強く推奨されている
# see: https://www.terraform.io/docs/backends/types/s3.html
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    # Disabled にできるわけではないので注意。
    # see: https://registry.terraform.io/providers/hashicorp%20%20/aws/latest/docs/resources/s3_bucket_versioning
    status = "Enabled"
  }
}

# tfstate には秘匿情報も含まれるため、一応バケットは暗号化していく
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket

  rule {
    # KMS を使うのは面倒なため、一旦はサーバーサイド暗号化 (SSE) で対応
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}