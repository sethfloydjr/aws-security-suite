# Create/Adopt Organization
resource "aws_organizations_organization" "awssecsuite" {
  feature_set = "ALL"

  aws_service_access_principals = [
    "account.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "detective.amazonaws.com",
    "macie.amazonaws.com",
    "iam.amazonaws.com"
  ]

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}


# ORGANIZATIONAL UNITS
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "logging" {
  name      = "Logging"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}


# MEMBER ACCOUNTS 
# (do NOT attempt to create the management account)
resource "aws_organizations_account" "security" {
  name                       = "awsss-security"
  email                      = var.security_account_email
  parent_id                  = aws_organizations_organizational_unit.security.id
  iam_user_access_to_billing = "DENY"
  role_name                  = "OrganizationAccountAccessRole"
  close_on_deletion          = false
}

resource "aws_organizations_account" "logging" {
  name                       = "awsss-logging"
  email                      = var.logging_account_email
  parent_id                  = aws_organizations_organizational_unit.logging.id
  iam_user_access_to_billing = "DENY"
  role_name                  = "OrganizationAccountAccessRole"
  close_on_deletion          = false
}


# We lock down root access to all other accounts in the org to only the root user of the root account.
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html#id_root-user-access-management
# For info on how to perform priveledged actions in other accounts see:
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user-privileged-task.html
resource "aws_iam_organizations_features" "centralized_root_access" {
  enabled_features = [
    "RootCredentialsManagement", # delete/disable long-term root creds in member accts
    "RootSessions"               # allow privileged root-only actions via managed sessions
  ]
}

# CloudTrail admin to live in Security instead of the root account
resource "aws_cloudtrail_organization_delegated_admin_account" "cloudtrail_admin" {
  account_id = aws_organizations_account.security.id
}
