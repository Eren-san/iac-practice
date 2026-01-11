resource "aws_dynamodb_table" "bootstrap_ddb_table" {
  name         = "bootstrap-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}