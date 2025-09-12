resource "aws_s3_bucket" "org_trail" {
  provider = aws.logging
  bucket   = var.trail_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "org_trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.org_trail.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

resource "aws_s3_bucket_public_access_block" "org_trail" {
  provider                = aws.logging
  bucket                  = aws_s3_bucket.org_trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "org_trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.org_trail.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "org_trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.org_trail.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # start with SSE-S3; move to KMS later if you want
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_policy" "org_trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.org_trail.id
  policy   = data.aws_iam_policy_document.org_trail_bucket.json
}
