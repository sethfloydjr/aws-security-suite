terraform {
  required_version = "1.13.1"
  required_providers {
    aws = {
      version = "> 6.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  alias  = "logging"
  region = "us-east-1"
  assume_role {
    role_arn = local.logging_org_access_role_arn
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = var.environment
    }
  }
}


provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = {
      Automation  = "Terraform"
      Environment = "logging"
    }
  }
}

# Additional providers can be added here as needed for bucket logging in other regions. See _variables.tf to "turn on" region.
