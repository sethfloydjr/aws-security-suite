# ORGANIZATIONAL UNITS
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "logging" {
  name      = "Logging"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}
