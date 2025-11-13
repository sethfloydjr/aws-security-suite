# MEMBER ACCOUNTS 
# (do NOT attempt to create the management account)
resource "aws_organizations_account" "security" {
  name                       = "awssecsuite-security"
  email                      = var.security_account_email
  parent_id                  = aws_organizations_organizational_unit.security.id
  iam_user_access_to_billing = "DENY"
  role_name                  = "OrganizationAccountAccessRole"
  close_on_deletion          = false
}


resource "aws_organizations_account" "logging" {
  name                       = "awssecsuite-logging"
  email                      = var.logging_account_email
  parent_id                  = aws_organizations_organizational_unit.logging.id
  iam_user_access_to_billing = "DENY"
  role_name                  = "OrganizationAccountAccessRole"
  close_on_deletion          = false
}
