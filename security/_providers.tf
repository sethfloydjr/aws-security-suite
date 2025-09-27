terraform {
  required_version = "1.13.1"
  required_providers {
    aws = {
      version = "> 6.0.0, < 7.0.0"
    }
  }
}

#Default provider which points to the "Root" account
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = var.environment
    }
  }
}

# Regional providers for Security account
provider "aws" {
  alias  = "security_us_east_1"
  region = "us-east-1"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "security_us_east_2"
  region = "us-east-2"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "security_us_west_1"
  region = "us-west-1"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "security_us_west_2"
  region = "us-west-2"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "security_eu_central_1"
  region = "eu-central-1"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "security_eu_west_1"
  region = "eu-west-1"
  assume_role { role_arn = local.security_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}

# Regional providers for Logging account (to create per-region destinations)
provider "aws" {
  alias  = "logging_us_east_1"
  region = "us-east-1"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "logging_us_east_2"
  region = "us-east-2"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "logging_us_west_1"
  region = "us-west-1"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "logging_us_west_2"
  region = "us-west-2"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "logging_eu_central_1"
  region = "eu-central-1"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
provider "aws" {
  alias  = "logging_eu_west_1"
  region = "eu-west-1"
  assume_role { role_arn = local.logging_org_access_role_arn }
  default_tags { tags = { Automation = "Terraform", Environment = var.environment } }
}
