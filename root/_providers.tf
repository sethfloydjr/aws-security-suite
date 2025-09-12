terraform {
  required_version = "1.13.1"
  required_providers {
    aws = {
      version = "> 6.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = var.environment
    }
  }
}
