variable "default_region" {
  default = "us-east-1"
}

variable "alternate_region" {
  default = "us-west-2"
}

variable "profile" {
  type        = string
  description = "Enter the local profile name to use for AWS authentication"
}

variable "project" {
  description = "This is the prefix to use in front of buckets, KMS keys, etc. Remember that AWS S3 buckets are globally named so your name should be unique to you and ideally you will follow the same naming convention for all of your buckets. Do not put underscores in bucket names."
}
