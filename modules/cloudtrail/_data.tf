data "aws_partition" "cur" {}

data "aws_caller_identity" "logging" {
  provider = aws.logging
}

data "aws_caller_identity" "security" {
  provider = aws.security
}

######################################
# BUCKET POLICY (AFTER TRAIL EXISTS)
######################################

data "aws_iam_policy_document" "trail_bucket" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [local.active_trail_bucket]
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${local.active_trail_bucket}/${var.key_prefix}/AWSLogs/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    # Tighten: allow writes only from this trail
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.trail_arn_for_kms]
    }
  }
}
