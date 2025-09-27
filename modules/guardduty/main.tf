############################################
# LOGGING ACCOUNT DESTINATION BUCKET
############################################

resource "aws_s3_bucket" "guardduty_logs" {
  provider = aws.logging
  bucket   = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  provider = aws.logging
  bucket   = aws_s3_bucket.guardduty_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  provider                = aws.logging
  bucket                  = aws_s3_bucket.guardduty_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  provider = aws.logging
  bucket   = aws_s3_bucket.guardduty_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  provider = aws.logging
  bucket   = aws_s3_bucket.guardduty_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_kms_key" "guardduty" {
  provider = aws.logging

  description             = "KMS key for GuardDuty publishing destination"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLoggingAccountRoot",
        Effect = "Allow",
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.logging.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "AllowGuardDutyUse",
        Effect = "Allow",
        Principal = {
          Service = "guardduty.amazonaws.com"
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ],
        Resource = "*",
        Condition = {
          ArnLike = {
            "aws:SourceArn" = local.guardduty_source_arn_pattern
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "guardduty" {
  provider      = aws.logging
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.guardduty.key_id
}

resource "aws_s3_bucket_policy" "logs" {
  provider = aws.logging
  bucket   = aws_s3_bucket.guardduty_logs.id
  policy   = data.aws_iam_policy_document.guardduty_logs.json
}


############################################
# SECURITY ACCOUNT GUARD DUTY SETUP
############################################

resource "aws_guardduty_detector" "this" {
  provider                     = aws.security
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency
}

# Replace deprecated datasources with explicit feature resources
resource "aws_guardduty_detector_feature" "s3_data_events" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "S3_DATA_EVENTS"
  status      = (var.auto_enable_s3_logs ? "ENABLED" : "DISABLED")
}

resource "aws_guardduty_detector_feature" "eks_audit_logs" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "EKS_AUDIT_LOGS"
  status      = (var.auto_enable_eks_audit_logs ? "ENABLED" : "DISABLED")
}

resource "aws_guardduty_detector_feature" "ebs_malware_protection" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "EBS_MALWARE_PROTECTION"
  status      = (var.auto_enable_malware_protection ? "ENABLED" : "DISABLED")
}

resource "aws_guardduty_organization_configuration" "this" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id

  # NEW = auto-enable for new org accounts in this region; NONE = do not auto-enable
  auto_enable_organization_members = var.auto_enable_organization_accounts ? "NEW" : "NONE"
}

resource "aws_guardduty_organization_configuration_feature" "org_s3_data_events" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "S3_DATA_EVENTS"
  auto_enable = var.auto_enable_s3_logs ? "NEW" : "NONE"
}

resource "aws_guardduty_organization_configuration_feature" "org_eks_audit_logs" {
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "EKS_AUDIT_LOGS"
  auto_enable = var.auto_enable_eks_audit_logs ? "NEW" : "NONE"
}

resource "aws_guardduty_organization_configuration_feature" "org_ebs_malware_protection" {
  count       = 0
  provider    = aws.security
  detector_id = aws_guardduty_detector.this.id
  name        = "EBS_MALWARE_PROTECTION"
  auto_enable = var.auto_enable_malware_protection ? "NEW" : "NONE"
}

resource "aws_guardduty_publishing_destination" "s3" {
  provider        = aws.security
  detector_id     = aws_guardduty_detector.this.id
  destination_arn = aws_s3_bucket.guardduty_logs.arn
  kms_key_arn     = local.kms_key_arn

  depends_on = [aws_s3_bucket_policy.logs]
}
