output "organization_id" {
  value = aws_organizations_organization.awssecsuite.id
}


output "security_name" {
  value = aws_organizations_account.security.name
}
output "security_id" {
  value = aws_organizations_account.security.id
}
output "security_arn" {
  value = aws_organizations_account.security.arn
}
output "security_email" {
  value = aws_organizations_account.security.email
}
output "security_status" {
  value = aws_organizations_account.security.status
}


output "logging_name" {
  value = aws_organizations_account.logging.name
}
output "logging_id" {
  value = aws_organizations_account.logging.id
}
output "logging_arn" {
  value = aws_organizations_account.logging.arn
}
output "logging_email" {
  value = aws_organizations_account.logging.email
}
output "logging_status" {
  value = aws_organizations_account.logging.status
}
