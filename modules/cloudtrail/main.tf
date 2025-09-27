# Expect provider aliases from the caller:
# - aws.root     -> Management (root) account
# - aws.security -> Security account (assume-role)
# - aws.logging  -> Logging account (assume-role)



############################
# LOGGING ACCOUNT RESOURCES
############################

resource "aws_s3_bucket" "trail" {
  provider = aws.logging
  bucket   = var.bucket_name
}

resource "aws_s3_bucket_policy" "trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.trail.id
  policy   = data.aws_iam_policy_document.trail_bucket.json
}


resource "aws_s3_bucket_logging" "s3_logging" {
  provider      = aws.logging
  bucket        = aws_s3_bucket.trail.id
  target_bucket = var.s3_logs_target_bucket
  target_prefix = "cloudtrail"
  target_object_key_format {
    partitioned_prefix { partition_date_source = "EventTime" }
  }

  lifecycle {
    precondition {
      condition     = var.s3_logs_target_bucket != null && var.s3_logs_target_bucket != ""
      error_message = "s3_logs_target_bucket is required and must match the logging bucket in region ${data.aws_region.current.region}."
    }
  }

}

resource "aws_s3_bucket_ownership_controls" "trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.trail.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

resource "aws_s3_bucket_public_access_block" "trail" {
  provider                = aws.logging
  bucket                  = aws_s3_bucket.trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.trail.id
  versioning_configuration {
    status = "Enabled"
  }
}

# SSE-S3 by default; can flip to KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "trail" {
  provider = aws.logging
  bucket   = aws_s3_bucket.trail.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.use_kms ? "aws:kms" : "AES256"
      kms_master_key_id = var.use_kms ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.trail[0].arn) : null
    }
    bucket_key_enabled = true
  }
}

# Optionally create a KMS key in Logging for CloudTrail objects
resource "aws_kms_key" "trail" {
  provider                = aws.logging
  count                   = var.use_kms && var.kms_key_arn == "" ? 1 : 0
  description             = "KMS key for CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  # *** Minimal initial policy: NO reference to the trail ARN here ***
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLoggingRoot",
        Effect = "Allow",
        Principal = {
          AWS = "arn:${data.aws_partition.cur.partition}:iam::${data.aws_caller_identity.logging.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "trail" {
  provider      = aws.logging
  count         = var.use_kms && var.kms_key_arn == "" ? 1 : 0
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.trail[0].key_id
}






#################################
# ORG TRAIL IN ROOT 
#################################
resource "aws_cloudtrail" "org_from_root" {
  provider                      = aws.root
  count                         = local.trail_owner_is_security ? 0 : 1
  name                          = "org-cloudtrail"
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  s3_bucket_name = aws_s3_bucket.trail.bucket
  s3_key_prefix  = var.key_prefix

  kms_key_id = var.use_kms ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.trail[0].arn) : null

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  dynamic "event_selector" {
    for_each = var.enable_data_events ? [1] : []
    content {
      read_write_type           = "All"
      include_management_events = false
      data_resource {
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }
      data_resource {
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda"]
      }
    }
  }
}

resource "aws_cloudtrail" "org_from_security" {
  provider                      = aws.security
  count                         = local.trail_owner_is_security ? 1 : 0
  name                          = "org-cloudtrail"
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  s3_bucket_name = aws_s3_bucket.trail.bucket
  s3_key_prefix  = var.key_prefix

  kms_key_id = var.use_kms ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.trail[0].arn) : null

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  dynamic "event_selector" {
    for_each = var.enable_data_events ? [1] : []
    content {
      read_write_type           = "All"
      include_management_events = false
      data_resource {
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }
      data_resource {
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda"]
      }
    }
  }
}








# Now that we know the trail ARN, optionally extend KMS key policy (if we created the key)
# After the trail exists, lock the key to the specific trail ARN
resource "aws_kms_key_policy" "trail" {
  provider = aws.logging
  count    = var.use_kms && var.kms_key_arn == "" ? 1 : 0
  depends_on = [
    aws_cloudtrail.org_from_root,
    aws_cloudtrail.org_from_security
  ]
  key_id = aws_kms_key.trail[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLoggingRoot",
        Effect = "Allow",
        Principal = {
          AWS = "arn:${data.aws_partition.cur.partition}:iam::${data.aws_caller_identity.logging.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid       = "AllowCloudTrailUse",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = ["kms:GenerateDataKey*", "kms:Encrypt", "kms:Decrypt", "kms:DescribeKey", "kms:ReEncrypt*"],
        Resource  = "*",
        Condition = {
          StringEquals = {
            "aws:SourceArn" = local.trail_arn_for_kms
          }
        }
      }
    ]
  })
}
