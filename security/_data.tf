data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket       = "awsss-terraform"
    key          = "root/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

data "terraform_remote_state" "logging" {
  backend = "s3"
  config = {
    bucket       = "awsss-terraform"
    key          = "logging/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

data "aws_organizations_organization" "org" {}
