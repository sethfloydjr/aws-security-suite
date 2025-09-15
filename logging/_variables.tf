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
