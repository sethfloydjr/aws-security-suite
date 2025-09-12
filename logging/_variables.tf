variable "default_region" {
  default = "us-east-1"
}
variable "backup_region" {
  default = "us-west-2"
}

variable "environment" {
  default     = "logging"
  description = "Environment tag to apply to resources"
}


###########################################################
#                      CONFIG VARS
###########################################################
variable "trail_bucket_name" {
  type        = string
  description = "Globally-unique bucket name for org CloudTrail logs"
}

variable "trail_prefix" {
  type    = string
  default = "cloudtrail"
}
