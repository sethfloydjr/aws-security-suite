output "state_bucket" {
  value = aws_s3_bucket.terraform_state_bucket.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.terraform_state.name
}

output "kms_key_arn" {
  value = aws_kms_key.terraform_state_bucket.arn
}
