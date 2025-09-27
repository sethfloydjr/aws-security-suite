data "aws_caller_identity" "security" {
  provider = aws.security
}

data "aws_caller_identity" "logging" {
  provider = aws.logging
}

data "aws_partition" "current" {}

data "aws_region" "security" {
  provider = aws.security
}

######################################
# GUARD DUTY BUCKET POLICY DOCUMENT
######################################

data "aws_iam_policy_document" "guardduty_logs" {
  statement {
    sid     = "AllowGuardDutyBucketAccess"
    effect  = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    resources = [aws_s3_bucket.guardduty_logs.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.security.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.guardduty_source_arn_pattern]
    }
  }

  statement {
    sid     = "AllowGuardDutyWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.guardduty_logs.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.security.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.guardduty_source_arn_pattern]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
