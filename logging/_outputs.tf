output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.org_trail.bucket
}

output "cloudtrail_bucket_arn" {
  value = aws_s3_bucket.org_trail.arn
}

output "cloudtrail_key_prefix" {
  value = var.trail_prefix
}
