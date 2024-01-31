locals {
  dynamodb_name = join("_", [local.app_id, "terraform", "tfstate", "lock"])
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = local.dynamodb_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = local.dynamodb_name
  }
}
