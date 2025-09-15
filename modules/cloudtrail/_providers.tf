terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Don’t pin the version here; it inherits from the root
      configuration_aliases = [
        aws.root,
        aws.security,
        aws.logging
      ]
    }
  }
}
