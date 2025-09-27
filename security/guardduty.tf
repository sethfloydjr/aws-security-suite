############################################
# Per-region GuardDuty deployment
############################################

module "guardduty_us_east_1" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_us_east_1
    aws.logging  = aws.logging_us_east_1
  }
  count = try(var.guardduty_enabled_regions["us-east-1"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-us-east-1"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}

module "guardduty_us_east_2" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_us_east_2
    aws.logging  = aws.logging_us_east_2
  }
  count = try(var.guardduty_enabled_regions["us-east-2"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-us-east-2"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}

module "guardduty_us_west_1" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_us_west_1
    aws.logging  = aws.logging_us_west_1
  }
  count = try(var.guardduty_enabled_regions["us-west-1"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-us-west-1"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}

module "guardduty_us_west_2" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_us_west_2
    aws.logging  = aws.logging_us_west_2
  }
  count = try(var.guardduty_enabled_regions["us-west-2"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-us-west-2"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}

module "guardduty_eu_central_1" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_eu_central_1
    aws.logging  = aws.logging_eu_central_1
  }
  count = try(var.guardduty_enabled_regions["eu-central-1"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-eu-central-1"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}

module "guardduty_eu_west_1" {
  source = "../modules/guardduty"
  providers = {
    aws.security = aws.security_eu_west_1
    aws.logging  = aws.logging_eu_west_1
  }
  count = try(var.guardduty_enabled_regions["eu-west-1"], false) ? 1 : 0

  bucket_name                       = "${var.guardduty_bucket_name}-eu-west-1"
  kms_key_alias                     = var.guardduty_kms_key_alias
  finding_publishing_frequency      = var.guardduty_finding_publishing_frequency
  auto_enable_organization_accounts = var.guardduty_auto_enable_new_accounts
  auto_enable_s3_logs               = var.guardduty_auto_enable_s3_logs
  auto_enable_eks_audit_logs        = var.guardduty_auto_enable_eks_audit_logs
  auto_enable_malware_protection    = var.guardduty_auto_enable_malware_protection
}
