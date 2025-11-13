# Creates the terraform state bucket, replication bucket, KMS keys to encrypt, and a DyanmoDB table to hepl with statefile locking.

# KMS key for TF state encryption
resource "aws_kms_key" "terraform_state_bucket" {
  description             = "KMS key for Terraform state bucket"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "terraform_state_bucket" {
  name          = "alias/${var.project}-terraform"
  target_key_id = aws_kms_key.terraform_state_bucket.key_id
}

# EAST BUCKET
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.project}-terraform"
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_bucket" {
  bucket                  = aws_s3_bucket.terraform_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state_bucket.arn
    }
    bucket_key_enabled = true
  }
}




# WEST BUCKET - REPLICATION TARGET
resource "aws_s3_bucket" "terraform_repl_state_bucket" {
  provider = aws.west
  bucket   = "${var.project}-terraform-replication"
}

resource "aws_s3_bucket_versioning" "terraform_repl_state_bucket" {
  provider = aws.west
  bucket   = aws_s3_bucket.terraform_repl_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_repl_state_bucket" {
  provider                = aws.west
  bucket                  = aws_s3_bucket.terraform_repl_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}




# BUCKET REPLICATION PERMISSIONS
resource "aws_iam_role" "bucket_replication" {
  name               = "${var.project}-terraform-bucket-replication"
  assume_role_policy = data.aws_iam_policy_document.bucket_assume_role.json
}

resource "aws_iam_policy" "bucket_replication" {
  name   = "${var.project}-terraform-bucket-replication"
  policy = data.aws_iam_policy_document.bucket_replication.json
}

resource "aws_iam_role_policy_attachment" "bucket_replication" {
  role       = aws_iam_role.bucket_replication.name
  policy_arn = aws_iam_policy.bucket_replication.arn
}




# REPLICATION

resource "aws_s3_bucket_replication_configuration" "bucket_replication" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.terraform_repl_state_bucket]

  role   = aws_iam_role.bucket_replication.arn
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    id = "terraform"

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.terraform_repl_state_bucket.arn
      storage_class = "STANDARD"
    }
  }
}

# DynamoDB lock table
resource "aws_dynamodb_table" "terraform_state" {
  name         = "${var.project}--terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  point_in_time_recovery { enabled = true }
}
