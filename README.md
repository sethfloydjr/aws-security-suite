# AWS-Security-Suite

A demonstration of deploying AWS security tooling using Terraform

---

# Assumptions

* You are familiar with AWS and the security tools and services they offer
* You are familiar with Terraform
* Im starting from scratch with a new AWS account. I manually set up the first root account and created a Terraform IAM user with full Admin permissions. Everything after this will be done through Terraform.

---

# Getting Started

Once you have created your first account and set up your root user with a MFA, create a terraform user and given it full Admin rights and configure the Access and Secret keys locally (or in your CICD pipeline). Now go to the Bootstrapper directory. Look at `_providers.tf` and set the versions of the AWS provider and the version of Terraform to what you want to use. Run the `boostrapper.sh` script. This script will create a S3 bucket and DynamoDB table in us-east-1 and then create a bucket in us-west-2 for replication. Versioning will be turned on and there is no lifecycle enabled for either bucket. You will want to delete the `terraform.tfstate` file that is created. You should never have a need to destroy the state bucket or the replica bucket so by removing the statefile that is created locally you reduce the chance of someone accidentally doing just that.

---

# How This Works

We have 3 AWS accounts:

* Root - The organization main account.
* Security - The account that holds all security services.
* Logging - The accounts that holds all logs for all services. There is very limited access to this account.

You may notice that the _backend.tf file is sparse. Since im building this locally and pushing to a public repo im hiding the backend configs. You can also do this or setup your backend how you normally would. I added `_backend.hcl` to my `.gitignore` so that they would not be committed to my repo and expose sensitive information.

My backend configuration for the root directory looks like this:

```
terraform {
  backend "s3" {}
}
```

But my `_backend.hcl` file looks like this:

```
bucket        = "BUCKET_NAME_GOES_HERE"
key           = "root/terraform.tfstate"
region        = "us-east-1"
dynamodb_table = "awsss-terraform-locks"
encrypt       = true
```

Once I have this setup for all 3 directories/accounts (while changing the respective key path) I run terraform init like so, `terraform init -backend-config=_backend.hcl` This allows me to hide certain configurations and still be able to push up a working example of this project. I have also hidden sensitive variables in tfvars files. Example tfvars files have been provided with dummy data included. Edit as you need.


# Components

## Org CloudTrail

Apply in this order:

1. ROOT - First we delegate the security account to be the admin for org cloudtrail.
2. LOGGING - Next we create the bucket resources in the Logging account
3. SECURITY - Now create the trail in the security account. This will deliver the logs to an S3 bucket in the Logging account. Your Logging account is the write-only archive; keep all log storage there.

---

# Notes

There are a few things to note before this is "production" ready. Firstly Im doing all of this work from my local so im using a local AWS profile that I set up. If this were in a production setting the profile would be replaced with a role that would be assumed that has the same or similar permission tot he Terraform IAM user I created at the start. Typically I would use a tool like Atlantis or a GitHub Action to do plans and applies and these tools would have the proper permissions setup. This will vary from company to company so you will have to fit this solution into your setup.

---

Please install terraform-docs to generate documentation for your repository.
[https://terraform-docs.io/user-guide/installation/](https://terraform-docs.io/user-guide/installation/)

The most common way of creating the doc is to run the following command inside your service directory:

terraform-docs markdown table . >> README.md

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 6.0.0, < 7.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS CLI profile to use | `string` | `""` | no |

## Outputs

No outputs.
