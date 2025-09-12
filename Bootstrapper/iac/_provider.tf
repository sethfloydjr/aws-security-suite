terraform {
  required_version = "1.13.1"
  required_providers {
    aws = {
      version = "> 6.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region  = var.default_region
  profile = var.profile
  default_tags {
    tags = {
      "Automation" = "Bootstrapped"
    }
  }
}

provider "aws" {
  alias   = "west"
  profile = var.profile
  region  = var.alternate_region
  default_tags {
    tags = {
      "Automation" = "Bootstrapped"
    }
  }
}
