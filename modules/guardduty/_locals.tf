locals {
  # Use wildcard region to avoid deprecated region attribute and still scope to the account
  guardduty_source_arn_pattern = "arn:${data.aws_partition.current.partition}:guardduty:*:${data.aws_caller_identity.security.account_id}:detector/*"

  kms_key_arn = aws_kms_key.guardduty.arn
}
