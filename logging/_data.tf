data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket       = "awsss-terraform"
    key          = "root/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

/*
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket       = "awsss-terraform"
    key          = "security/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
*/


data "aws_organizations_organization" "org" {}

# Bucket policy that lets CloudTrail write.
# (If you later want extra hardening, you can add an aws:SourceArn condition once the trail exists.)
data "aws_iam_policy_document" "org_trail_bucket" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_s3_bucket.org_trail.arn]
  }

  # Allow org trail writes under the chosen prefix, using org-wide path
  statement {
    sid     = "AWSCloudTrailWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [
      "${aws_s3_bucket.org_trail.arn}/${var.trail_prefix}/AWSLogs/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
