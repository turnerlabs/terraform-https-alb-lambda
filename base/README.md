# Base Terraform

Creates the foundational infrastructure for the application's infrastructure.
These Terraform files will create a [remote state][state] s3 bucket.
Most other infrastructure pieces will be created within the `env` directory.


## Included Files

+ `main.tf`  
The main entry point for the Terraform run.

+ `variables.tf`  
Common variables to use in various Terraform files.

+ `state.tf`  
Generate a [remote state][state] bucket in S3 for use with later Terraform runs.


## Usage

Typically, the base Terraform will only need to be run once, and then should only
need changes very infrequently.

```
# Sets up Terraform to run
$ terraform init

# Executes the Terraform run
$ terraform apply
```

main.tf
The main entry point for Terraform run
See variables.tf for common variables
See ecr.tf for creation of Elastic Container Registry for all environments
See state.tf for creation of S3 bucket for remote state


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app | Name of the application. This value should usually match the application tag below. | string | - | yes |
| aws_profile | The AWS profile to use, this would be the same value used in AWS_PROFILE. | string | - | yes |
| region | The AWS region to use for the bucket and registry; typically `us-east-1`. Other possible values: `us-east-2`, `us-west-1`, or `us-west-2`. Currently, Fargate is only available in `us-east-1`. | string | `us-east-1` | no |
| saml_role | The role that will have access to the S3 bucket, this should be a role that all members of the team have access to. | string | - | yes |
| tags | A map of the tags to apply to various resources. The required tags are: `application`, name of the app; `environment`, the environment being created; `team`, team responsible for the application; `contact-email`, contact email for the _team_; and `customer`, who the application was create for. | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket | Returns the name of the S3 bucket that will be used in later Terraform files |


## Additional Information

+ [Terraform remote state][state]

+ [Terraform providers][provider]

[state]: https://www.terraform.io/docs/state/remote.html
[provider]: https://www.terraform.io/docs/providers/
