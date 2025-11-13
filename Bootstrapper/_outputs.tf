output "state_bucket" {
  value = aws_s3_bucket.terraform_state_bucket.bucket
}

output "aws_iam_user_access_terraform" {
  value     = aws_iam_access_key.terraform.secret
  sensitive = true
}
