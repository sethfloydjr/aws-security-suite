variable "bucket_name" {
  type = string
}

variable "key_prefix" {
  type    = string
  default = "cloudtrail"
}

variable "admin_account" {
  type    = string
  default = "security" # or "management"
  validation {
    condition     = contains(["management", "security"], var.admin_account)
    error_message = "admin_account must be 'management' or 'security'."
  }
}

variable "delegate_security_as_admin" {
  type    = bool
  default = true
}

variable "enable_data_events" {
  type    = bool
  default = true
}

variable "use_kms" {
  type    = bool
  default = false
}

variable "kms_key_alias" {
  type    = string
  default = "alias/cloudtrail-logs"
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "s3_logs_target_bucket" {
  description = "S3 bucket that will receive Server Access Logs for the CloudTrail bucket"
  type        = string
}
