locals {
  logging_account_id  = data.terraform_remote_state.root.outputs.logging_id
  security_account_id = data.terraform_remote_state.root.outputs.security_id

  logging_org_access_role_arn  = "arn:aws:iam::${local.logging_account_id}:role/OrganizationAccountAccessRole"
  security_org_access_role_arn = "arn:aws:iam::${local.security_account_id}:role/OrganizationAccountAccessRole"
}
