resource "aws_iam_role_policy_attachment" "security_org_readonly" {
  provider   = aws.security_us_east_1
  role       = "OrganizationAccountAccessRole"
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}
