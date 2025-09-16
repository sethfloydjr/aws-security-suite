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

#######################################################
#                      S3 LOGGING
#######################################################
# Turn regions on/off here
variable "enabled_regions" {
  description = "Map of regions to bool; true => create a bucket in that region"
  type        = map(bool)
  #See _variables.auto.tfvars.example for mapp example
}

variable "bucket_name_prefix" {
  description = "Prefix for logging buckets; final name is <prefix>-<region>"
  type        = string
}

variable "sequester_bucket_name" {
  description = "Globally-unique name for the sequester bucket (required if enable_sequester=true)"
  type        = string
}
