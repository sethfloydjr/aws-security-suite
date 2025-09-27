variable "default_region" {
  default = "us-east-1"
}
variable "backup_region" {
  default = "us-west-2"
}

variable "environment" {
  default     = "security"
  description = "Environment tag to apply to resources"
}


###########################################################
#                      CONFIG VARS
###########################################################
variable "cloudtrail_bucket_name" {
  type = string
}

variable "cloudtrail_key_prefix" {
  type    = string
  default = "cloudtrail"
}

variable "bucket" {
  type = string
}

variable "key" {
  type = string
}

variable "region" {
  type = string
}

variable "dynamodb_table" {
  type = string
}

variable "encrypt" {
  type = bool
}


###########################################################
#                      GUARDDUTY VARS
###########################################################
variable "guardduty_bucket_name" {
  description = "S3 bucket to store GuardDuty findings"
  type        = string
}

variable "guardduty_use_kms" {
  description = "Create a customer managed KMS key for GuardDuty findings"
  type        = bool
  default     = true
}

variable "guardduty_kms_key_alias" {
  description = "Alias for the GuardDuty KMS key when created"
  type        = string
}

variable "guardduty_finding_publishing_frequency" {
  description = "How often GuardDuty publishes findings"
  type        = string
  default     = "SIX_HOURS"
}

variable "guardduty_auto_enable_new_accounts" {
  description = "Automatically enable GuardDuty for new organization accounts"
  type        = bool
  default     = true
}

variable "guardduty_auto_enable_s3_logs" {
  description = "Auto-enable S3 protection when new accounts join"
  type        = bool
  default     = true
}

# Multi-region deployment controls
variable "guardduty_enabled_regions" {
  description = "Map of regions to bool; true => enable GuardDuty in that region. See variables.auto.tfvars.example for available regions"
  type        = map(bool)
}

# Control whether the module manages the org-level EBS malware auto-enable flag (set true AFTER first apply.)
variable "guardduty_manage_org_ebs_auto_enable" {
  description = "Manage org-level EBS malware auto-enable (set true after a one-time bootstrap)"
  type        = bool
  default     = true
}

variable "guardduty_auto_enable_eks_audit_logs" {
  description = "Auto-enable EKS audit log monitoring for new accounts"
  type        = bool
  default     = false #Available but not enabled by default since there is no EKS cluster here.
}

variable "guardduty_auto_enable_malware_protection" {
  description = "Auto-enable GuardDuty malware protection for new accounts"
  type        = bool
  default     = true
}
