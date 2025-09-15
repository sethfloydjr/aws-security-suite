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
