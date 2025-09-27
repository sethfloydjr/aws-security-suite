# AWS-Security-Suite

A demonstration of deploying AWS security tooling using Terraform



# Assumptions

* You are familiar with AWS and the security tools and services they offer
* You are familiar with Terraform
* Im starting from scratch with a new AWS account. I manually set up the first root account and created a Terraform IAM user with full Admin permissions. Everything after this will be done through Terraform.



# Getting Started

Once you have created your first account and set up your root user with a MFA, create a terraform user and given it full Admin rights and configure the Access and Secret keys locally (or in your CICD pipeline). Now go to the Bootstrapper directory. Look at `_providers.tf` and set the versions of the AWS provider and the version of Terraform to what you want to use. Run the `boostrapper.sh` script. This script will create a S3 bucket and DynamoDB table in us-east-1 and then create a bucket in us-west-2 for replication. Versioning will be turned on and there is no lifecycle enabled for either bucket. You will want to delete the `terraform.tfstate` file that is created. You should never have a need to destroy the state bucket or the replica bucket so by removing the statefile that is created locally you reduce the chance of someone accidentally doing just that.



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

## Trufflehog

For secret exposure mitigation im just using the basic Trufflehog scan. More info can be found [here}(https://github.com/trufflesecurity/trufflehog/tree/main?tab=readme-ov-file#general-usage)

## Org CloudTrail

Apply in this order:

1. ROOT - First we delegate the security account to be the admin for org cloudtrail.
2. LOGGING - Next we create the bucket resources in the Logging account
3. SECURITY - Now create the trail in the security account. This will deliver the logs to an S3 bucket in the Logging account. Your Logging account is the write-only archive; keep all log storage there.

## S3 Bucket Logging

This sets up "S3 Server Logging". It creates a bucket per region that you enable. That bucket is the central storage place for that region of all other S3 buckets that have logging turned on. Logging is specifically NOT turned on for these because because it would cause an infinate loop of logs logging logs. Each bucket enables the following:

* Versioning + SSE-S3
* Ownership enforced + public access blocked
* Lifecycle: 30 → STANDARD_IA, 60 → GLACIER, 365 → expire
* Object Lock enabled, so objects won’t delete if on legal hold

(Optional) Sequester workflow: when a legal hold is placed on any object in either bucket, an EventBridge → Lambda flow copies that object to a separate “sequestered” bucket. This is enabled per region and is "turned on" at the module call in `logging/s3_logging.tf`. Remember that if you turn this on the objects that are set for a legal hold will be moved to the corresponding regional sequester bucket. You will need to do some cross-account IAM work to be able to manipulate the objects from outside of the account or region as you will not have default access to the bucket in the logging account.

Pros

* Strongest separation: sensitive/held objects stay in-region (good for residency, least-privilege, incident blast radius).
* No cross-region transfer costs for the copy.
* Per-region IAM boundaries (you can delegate or lock down region by region).

Cons

* You’ll have multiple buckets to search when doing discovery.
* Slightly more infra: EventBridge + Lambda + IAM per region.

If you want to set all objects to have a lock hold for X number of days add this to your code. If you want all logs held for a fixed period, this is the easiest way. Lifecycle will not delete those objects until the 30-day retention expires:

```
resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket              = aws_s3_bucket.logging.id
  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 30   # every new object is locked for 30 days by default
    }
  }
}
```

If you only want a certain object to be held for a legal hold for X number of days then you would do soemthing like this:

```
aws s3api put-object-retention \
  --bucket awsss-s3-logging-us-east-1 \
  --key logs/2025/09/15/log.json \
  --retention '{"Mode":"GOVERNANCE","RetainUntilDate":"2025-12-15T00:00:00Z"}'
```

Or apply a legal hold:

```
aws s3api put-object-legal-hold \
  --bucket awsss-s3-logging-us-east-1 \
  --key logs/2025/09/15/log.json \
  --legal-hold Status=ON
```

This is how you “manually” lock only certain objects beyond the default period.


Notes:

* S3 Lifecycle cannot filter by legal hold status, so automatic sequester requires an event-driven flow. We use the CloudTrail “AWS API Call via CloudTrail” event for PutObjectLegalHold to trigger Lambda. A small lambda has been provided in the S3_logging module.

* Object Lock requires enabling it at bucket creation. Terraform sets object_lock_enabled = true and then we attach an object-lock config (no default retention; legal holds still work).

### How “legal hold” + sequester works

Object Lock ensures lifecycle won’t delete objects under legal hold. When someone sets a legal hold (PutObjectLegalHold), CloudTrail emits an event; EventBridge rule matches it and invokes Lambda. Lambda copies that object to your sequester bucket. You may additionally have Lambda put a legal hold on the copy (commented code provided). If you’d rather not deploy Lambda/EventBridge now, set enable_sequester = false. Legal holds are still respected (deletes/expiration will skip those objects). For more information see the [AWS Object Lock documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html)

## Guardduty

* What it does
  * Security account: Creates a GuardDuty detector per enabled region and enables features (S3 data events, EBS malware; EKS audit logs optional).
  * Logging account: Creates hardened, regional S3 buckets for findings plus regional KMS keys.
  * Organization: Sets org members to NEW (auto‑onboard new accounts) in each enabled region.

* Why use it
  * Centralizes findings in a restricted Logging account with per‑region CMKs.
  * Least‑privilege S3/KMS policies (scoped by `SourceAccount`/`SourceArn`).
  * Scales org‑wide: new accounts are auto‑enabled in chosen regions.

* Prereqs
  * Apply the root stack to delegate GuardDuty admin to the Security account (see `root/organization.tf`).

* Configure (in `security/_variables.auto.tfvars`)
  * Enable regions (true = create detector, bucket, KMS, destination):
    * `guardduty_enabled_regions = { "us-east-1" = true, "us-west-2" = true, ... }`
  * Findings bucket naming (base name; module appends `-<region>`):
    * `guardduty_bucket_name = "your-unique-prefix"`
  * Org/new-account handling and features:
    * `guardduty_auto_enable_new_accounts = true`        # org members set to NEW
    * `guardduty_auto_enable_s3_logs = true`             # org feature S3_DATA_EVENTS = NEW
    * `guardduty_auto_enable_eks_audit_logs = false`     # EKS audit logs off by default
    * `guardduty_auto_enable_malware_protection = true`  # detector feature EBS malware = ENABLED

* Enable EKS audit logs
  * Turn ON by setting: `guardduty_auto_enable_eks_audit_logs = true`
  * Effects:
    * Detector feature KUBERNETES_AUDIT_LOGS = ENABLED
    * Org feature EKS_AUDIT_LOGS = NEW (auto‑enroll for new accounts in enabled regions)

* Enable EBS malware protection
  * Detector‑level scanning is ON by default (`guardduty_auto_enable_malware_protection = true`) and findings publish to the Logging bucket.
  * Org‑wide auto‑enroll for EBS malware (enable for all new/existing members) is not managed by default to ensure first apply succeeds everywhere. If you want it ON org‑wide now, run (Security account, per region):
    * `aws guardduty update-organization-configuration --region <region> --detector-id <detector-id> --features name=EBS_MALWARE_PROTECTION,autoEnable=NEW`
  * After that, you can choose to manage the org EBS auto‑enable in code if desired.

* Apply and verify
  * Apply order: `cd root && terraform apply` → `cd security && terraform apply`
  * Findings land in Logging: `s3://<guardduty_bucket_name>-<region>/`
  * Quick test (Security account):
    * `aws guardduty list-detectors --region <region>`
    * `aws guardduty list-publishing-destinations --detector-id <id> --region <region>`
    * `aws guardduty create-sample-findings --detector-id <id> --region <region>`
  * Org config check:
    * `aws guardduty describe-organization-configuration --detector-id <id> --region <region>`
    * Expect: `AutoEnableOrganizationMembers = NEW`, `S3_DATA_EVENTS = NEW`, `EKS_AUDIT_LOGS = NONE` (unless enabled). Detector feature `EBS_MALWARE_PROTECTION = ENABLED`.

* Files
  * `security/guardduty.tf` (per‑region modules and providers)
  * `modules/guardduty/*` (detector, features, publishing, KMS, S3 policy)

# Notes

There are a few things to note before this is "production" ready. Firstly Im doing all of this work from my local so im using a local AWS profile that I set up. If this were in a production setting the profile would be replaced with a role that would be assumed that has the same or similar permission tot he Terraform IAM user I created at the start. Typically I would use a tool like Atlantis or a GitHub Action to do plans and applies and these tools would have the proper permissions setup. This will vary from company to company so you will have to fit this solution into your setup.



## Requirements

This is performed in each directory where TF files live.

Please install terraform-docs to generate documentation for your repository.
[https://terraform-docs.io/user-guide/installation/](https://terraform-docs.io/user-guide/installation/)

The most common way of creating the doc is to run the following command inside your service directory:

terraform-docs markdown table . >> README.md
