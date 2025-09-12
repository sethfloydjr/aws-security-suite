# Create the organization trail in the security account
resource "aws_cloudtrail" "org" {
  name                          = "awsss-org-cloudtrail"
  provider                      = aws.security
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  s3_bucket_name = var.cloudtrail_bucket_name
  s3_key_prefix  = var.cloudtrail_key_prefix

  # Management events (read/write)
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  # Data events — start with S3 & Lambda; you can tune for cost later. This gets expensive!
  # S3 object-level (all buckets) and Lambda function-level logging.
  event_selector {
    read_write_type           = "All"
    include_management_events = false
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"] # all buckets; later you can scope to critical buckets
    }
    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}
