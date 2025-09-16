locals {
  bucket_name         = "${var.bucket_name_prefix}-${data.aws_region.current.region}"
  to_standard_ia_days = 30
  to_glacier_days     = 60
  expire_days         = 365
}
