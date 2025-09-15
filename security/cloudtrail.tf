/*
module "cloudtrail" {
  source = "../modules/cloudtrail"
  providers = {
    aws.root     = aws          # default = mgmt/root
    aws.security = aws.security # assumed role into security
    aws.logging  = aws.logging  # assumed role into logging
  }
  bucket_name                = "awsss-org-cloudtrail-logs" # put in secrets.auto.tfvars
  key_prefix                 = "cloudtrail"
  admin_account              = "security" # Security creates/manages the org trail
  delegate_security_as_admin = true
  enable_data_events         = false # Check pricing before setting this to true.
  use_kms                    = false # flip later if you want KMS in Logging
}
*/
