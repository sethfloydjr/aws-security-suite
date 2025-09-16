# One module block per region; count toggled via enabled_regions

module "s3_logging_us_east_1" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.us_east_1 }
  count                 = try(var.enabled_regions["us-east-1"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}

module "s3_logging_us_east_2" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.us_east_2 }
  count                 = try(var.enabled_regions["us-east-2"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}

module "s3_logging_us_west_1" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.us_west_1 }
  count                 = try(var.enabled_regions["us-west-1"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}

module "s3_logging_us_west_2" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.us_west_2 }
  count                 = try(var.enabled_regions["us-west-2"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}

module "s3_logging_eu_central_1" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.eu_central_1 }
  count                 = try(var.enabled_regions["eu-central-1"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}

module "s3_logging_eu_west_1" {
  source                = "../modules/s3_logging"
  providers             = { aws = aws.eu_west_1 }
  count                 = try(var.enabled_regions["eu-west-1"], false) ? 1 : 0
  bucket_name_prefix    = var.bucket_name_prefix
  enable_sequester      = false
  sequester_bucket_name = var.sequester_bucket_name
}
