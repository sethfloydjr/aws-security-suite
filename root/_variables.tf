variable "default_region" {
  default = "us-east-1"
}
variable "backup_region" {
  default = "us-west-2"
}

variable "environment" {
  default     = "root"
  description = "Environment tag to apply to resources"
}

variable "security_account_email" {
  description = "Email for the Security account"
  type        = string
}

variable "logging_account_email" {
  description = "Email for the Logging account"
  type        = string
}
