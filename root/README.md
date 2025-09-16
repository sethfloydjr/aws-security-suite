## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 6.0.0, < 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.13.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail_organization_delegated_admin_account.cloudtrail_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_organization_delegated_admin_account) | resource |
| [aws_iam_organizations_features.centralized_root_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_organizations_features) | resource |
| [aws_organizations_account.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_account.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_organization.awssecsuite](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag to apply to resources | `string` | `"root"` | no |
| <a name="input_logging_account_email"></a> [logging\_account\_email](#input\_logging\_account\_email) | Email for the Logging account | `string` | n/a | yes |
| <a name="input_security_account_email"></a> [security\_account\_email](#input\_security\_account\_email) | Email for the Security account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logging_arn"></a> [logging\_arn](#output\_logging\_arn) | n/a |
| <a name="output_logging_email"></a> [logging\_email](#output\_logging\_email) | n/a |
| <a name="output_logging_id"></a> [logging\_id](#output\_logging\_id) | n/a |
| <a name="output_logging_name"></a> [logging\_name](#output\_logging\_name) | n/a |
| <a name="output_logging_status"></a> [logging\_status](#output\_logging\_status) | n/a |
| <a name="output_organization_id"></a> [organization\_id](#output\_organization\_id) | n/a |
| <a name="output_security_arn"></a> [security\_arn](#output\_security\_arn) | n/a |
| <a name="output_security_email"></a> [security\_email](#output\_security\_email) | n/a |
| <a name="output_security_id"></a> [security\_id](#output\_security\_id) | n/a |
| <a name="output_security_name"></a> [security\_name](#output\_security\_name) | n/a |
| <a name="output_security_status"></a> [security\_status](#output\_security\_status) | n/a |
