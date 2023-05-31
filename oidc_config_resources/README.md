# OIDC config terraform module

Create rosa OIDC config's resources in AWS using 
Terraform AWS ROSA STS

## Prerequisites

* AWS Admin Account configured by using AWS CLI in AWS configuration file
* terraform cli
* provider AWS - to get account details 

## Inputs
| Name | type        | Description                                                                                                                                        | Example                                                                     |
|------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
|bucket_name| string      | The S3 bucket name                                                                                                                                         | "oidc-f3y4"                                                                 |
|discovery_doc| string      | The discovery document string file                                                                                                                                  |  |
|jwks| string      | Json web key set string file                                                                                          |                                    |
|private_key| string      | RSA private key                                                                                          |                                    |
|private_key_file_name| string      | The private key file name                                                                                          | "rosa-private-key-oidc-f3y4.key"                                  |
|private_key_secret_name| string      | The secret name that store the private key                                                                                          | "rosa-private-key-oidc-f3y4"                                  |
|tags | map of strings | List of AWS resource tags to apply | [an example can be found below](#tags-object) |

### tags object
`tags` is a map of strings with resource tags to be applied to AWS resources created.
The map looks like:
```
{
  contact     = "xyz@company.com"
  cost-center = "12345"
  owner       = "productteam"
  environment = "test"
}
```

## Usage

### Sample Usage

```
module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.5"

   create_oidc_config_resources = true

  bucket_name = var.bucket_name
  discovery_doc = var.discovery_doc
  jwks = var.jwks
  private_key = var.private_key
  private_key_file_name = var.private_key_file_name
  private_key_secret_name = var.private_key_secret_name
}

```

## The module uses the following resources
* aws_s3_bucket
* aws_s3_bucket_public_access_block
* aws_s3_bucket_policy
* aws_iam_policy_document
* aws_secretsmanager_secret
* aws_secretsmanager_secret_version
* aws_s3_object

