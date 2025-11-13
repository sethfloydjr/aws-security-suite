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

# GuardDuty admin to live in Security instead of the root account
resource "aws_guardduty_organization_admin_account" "guardduty_admin" {
  depends_on       = [aws_organizations_organization.awssecsuite]
  admin_account_id = aws_organizations_account.security.id
}
