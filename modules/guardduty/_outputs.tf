output "bucket_name" {
  description = "GuardDuty findings destination bucket name"
  value       = aws_s3_bucket.guardduty_logs.bucket
}

output "bucket_arn" {
  description = "GuardDuty findings destination bucket ARN"
  value       = aws_s3_bucket.guardduty_logs.arn
}

output "detector_id" {
  description = "GuardDuty detector ID in the security account"
  value       = aws_guardduty_detector.this.id
}

output "publishing_destination_arn" {
  description = "ARN of the GuardDuty publishing destination"
  value       = aws_guardduty_publishing_destination.s3.destination_arn
}

output "kms_key_arn" {
  description = "KMS key ARN used for GuardDuty findings (if configured)"
  value       = aws_kms_key.guardduty.arn
}
