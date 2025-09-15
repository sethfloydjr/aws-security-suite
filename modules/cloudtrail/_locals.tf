locals {
  trail_owner_is_security = var.admin_account == "security"

  # Helper local: the active trail ARN (for KMS & bucket policy)
  trail_arn_for_kms   = coalesce(try(aws_cloudtrail.org_from_root[0].arn, null), try(aws_cloudtrail.org_from_security[0].arn, null))
  active_trail_bucket = aws_s3_bucket.trail.arn
}
