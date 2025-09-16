## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 6.0.0, < 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.13.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.root](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | `string` | n/a | yes |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | ########################################################## CONFIG VARS ########################################################## | `string` | n/a | yes |
| <a name="input_cloudtrail_key_prefix"></a> [cloudtrail\_key\_prefix](#input\_cloudtrail\_key\_prefix) | n/a | `string` | `"cloudtrail"` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table) | n/a | `string` | n/a | yes |
| <a name="input_encrypt"></a> [encrypt](#input\_encrypt) | n/a | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag to apply to resources | `string` | `"security"` | no |
| <a name="input_key"></a> [key](#input\_key) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
