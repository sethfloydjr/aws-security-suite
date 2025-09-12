terraform {
  required_version = "1.13.1"
  required_providers {
    aws = {
      version = "> 6.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  alias  = "security"
  region = "us-east-1"
  assume_role {
    role_arn = local.security_org_access_role_arn
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = var.environment
    }
  }
}
