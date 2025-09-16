resource "aws_s3_bucket" "logging" {
  bucket              = local.bucket_name
  object_lock_enabled = true
}

resource "aws_s3_bucket_policy" "logging_log_delivery" {
  bucket = aws_s3_bucket.logging.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSLogDeliveryAclCheck",
        Effect = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com"
        },
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ],
        Resource = aws_s3_bucket.logging.arn
      },
      {
        Sid       = "AWSLogDeliveryWrite",
        Effect    = "Allow",
        Principal = { Service = "logging.s3.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.logging.arn}/*",
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
        }
      }
    ]
  })
}


resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.logging.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.logging.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.logging.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
    bucket_key_enabled = true
  }
}

# Object Lock config (no default retention; legal holds still block deletion)
resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket              = aws_s3_bucket.logging.id
  object_lock_enabled = "Enabled"
}

# Lifecycle: 30→STANDARD_IA, 60→GLACIER, 365→expire
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "log-lifecycle"
    status = "Enabled"
    filter { prefix = "" }

    transition {
      days          = local.to_standard_ia_days
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = local.to_glacier_days
      storage_class = "GLACIER"
    }
    expiration { days = local.expire_days }

    noncurrent_version_transition {
      noncurrent_days = local.to_standard_ia_days
      storage_class   = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = local.to_glacier_days
      storage_class   = "GLACIER"
    }
    noncurrent_version_expiration { noncurrent_days = local.expire_days }
  }
}


# SEQUESTER BUCKET (for Legal Holds)
# Anything below here is only created when `enable_sequester = true` in logging/s3_logging.tf

resource "aws_s3_bucket" "sequester" {
  count               = var.enable_sequester ? 1 : 0
  bucket              = var.sequester_bucket_name
  object_lock_enabled = true
  tags                = merge(var.tags, { Purpose = "SequesteredObjects" })
}

resource "aws_s3_bucket_ownership_controls" "sequester" {
  count  = var.enable_sequester ? 1 : 0
  bucket = aws_s3_bucket.sequester[0].id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "sequester" {
  count                   = var.enable_sequester ? 1 : 0
  bucket                  = aws_s3_bucket.sequester[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "sequester" {
  count  = var.enable_sequester ? 1 : 0
  bucket = aws_s3_bucket.sequester[0].id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sequester" {
  count  = var.enable_sequester ? 1 : 0
  bucket = aws_s3_bucket.sequester[0].id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
    bucket_key_enabled = true
  }
}

# Object Lock config: no default retention; held objects can also be retained if you wish
resource "aws_s3_bucket_object_lock_configuration" "sequester" {
  count               = var.enable_sequester ? 1 : 0
  bucket              = aws_s3_bucket.sequester[0].id
  object_lock_enabled = "Enabled"
}
