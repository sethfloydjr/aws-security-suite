output "bucket_name" {
  value = aws_s3_bucket.trail.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.trail.arn
}

output "trail_arn" {
  value = local.trail_arn_for_kms
}

output "kms_key_arn" {
  value = var.use_kms ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.trail[0].arn) : null
}

output "key_prefix" {
  value = var.key_prefix
}
