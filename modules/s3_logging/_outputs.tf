output "bucket_name" {
  value       = aws_s3_bucket.logging.bucket
  description = "The created logging bucket name"
}
