variable "bucket_name_prefix" {
  description = "Prefix for the logging bucket name; final name becomes <prefix>-<region>"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_sequester" {
  description = "Copy objects to a separate bucket when a Legal Hold is applied"
  type        = bool
}

variable "sequester_bucket_name" {
  description = "Globally-unique name for the sequester bucket (required if enable_sequester=true)"
  type        = string
}
