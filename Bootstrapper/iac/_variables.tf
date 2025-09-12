variable "default_region" {
  default = "us-east-1"
}

variable "alternate_region" {
  default = "us-west-2"
}

variable "profile" {
  description = "Enter the local profile name to use for AWS authentication"
}

variable "lock_table" {
  type = string
}

variable "kms_alias" {
  type = string
}
