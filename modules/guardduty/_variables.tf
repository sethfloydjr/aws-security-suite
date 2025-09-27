variable "bucket_name" {
  description = "Name for the GuardDuty findings destination bucket (must be globally unique)"
  type        = string
}

variable "kms_key_alias" {
  description = "Alias to apply to the managed KMS key created in the logging account"
  type        = string
  default     = "alias/guardduty-findings"
}

variable "finding_publishing_frequency" {
  description = "How frequently GuardDuty publishes findings"
  type        = string
  default     = "SIX_HOURS"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "finding_publishing_frequency must be FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  }
}

variable "auto_enable_organization_accounts" {
  description = "Automatically enable GuardDuty for new organization accounts"
  type        = bool
  default     = true
}

variable "auto_enable_s3_logs" {
  description = "Auto-enable S3 protection for new organization accounts"
  type        = bool
  default     = true
}

variable "auto_enable_eks_audit_logs" {
  description = "Auto-enable EKS audit log monitoring for new organization accounts"
  type        = bool
  default     = false
}

variable "auto_enable_malware_protection" {
  description = "Auto-enable GuardDuty malware protection for new organization accounts"
  type        = bool
  default     = true
}

# Control whether the module manages the ORG-level auto-enable for EBS malware protection.
# Default false to avoid first-run failures when AWS requires a management-account bootstrap.
variable "manage_org_ebs_auto_enable" {
  description = "Manage org-level EBS malware auto-enable (set true after bootstrap)"
  type        = bool
  default     = false
}
