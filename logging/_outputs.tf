output "s3_logging_buckets" {
  description = "All S3 logging buckets created by region"
  value = {
    us-east-1    = try(module.s3_logging_us_east_1[0].bucket_name, null)
    us-east-2    = try(module.s3_logging_us_east_2[0].bucket_name, null)
    us-west-1    = try(module.s3_logging_us_west_1[0].bucket_name, null)
    us-west-2    = try(module.s3_logging_us_west_2[0].bucket_name, null)
    eu-central-1 = try(module.s3_logging_eu_central_1[0].bucket_name, null)
    eu-west-1    = try(module.s3_logging_eu_west_1[0].bucket_name, null)
  }
}
