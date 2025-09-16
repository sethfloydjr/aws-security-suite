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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_logging_eu_central_1"></a> [s3\_logging\_eu\_central\_1](#module\_s3\_logging\_eu\_central\_1) | ../modules/s3_logging | n/a |
| <a name="module_s3_logging_eu_west_1"></a> [s3\_logging\_eu\_west\_1](#module\_s3\_logging\_eu\_west\_1) | ../modules/s3_logging | n/a |
| <a name="module_s3_logging_us_east_1"></a> [s3\_logging\_us\_east\_1](#module\_s3\_logging\_us\_east\_1) | ../modules/s3_logging | n/a |
| <a name="module_s3_logging_us_east_2"></a> [s3\_logging\_us\_east\_2](#module\_s3\_logging\_us\_east\_2) | ../modules/s3_logging | n/a |
| <a name="module_s3_logging_us_west_1"></a> [s3\_logging\_us\_west\_1](#module\_s3\_logging\_us\_west\_1) | ../modules/s3_logging | n/a |
| <a name="module_s3_logging_us_west_2"></a> [s3\_logging\_us\_west\_2](#module\_s3\_logging\_us\_west\_2) | ../modules/s3_logging | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.root](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_bucket_name_prefix"></a> [bucket\_name\_prefix](#input\_bucket\_name\_prefix) | Prefix for logging buckets; final name is <prefix>-<region> | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_enabled_regions"></a> [enabled\_regions](#input\_enabled\_regions) | Map of regions to bool; true => create a bucket in that region | `map(bool)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag to apply to resources | `string` | `"logging"` | no |
| <a name="input_sequester_bucket_name"></a> [sequester\_bucket\_name](#input\_sequester\_bucket\_name) | Globally-unique name for the sequester bucket (required if enable\_sequester=true) | `string` | n/a | yes |

## Outputs

No outputs.
