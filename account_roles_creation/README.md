# Account roles terraform module

Create rosa account IAM roles in a declarative way
Terraform AWS ROSA STS


## Prerequisites
* OCM Account and OCM CLI
* terraform cli
* provider AWS - to get account details 

## Inputs
| Name | type        | Description                                                                                                                                        | Example            |
|------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
|account_role_prefix| string      | Account roles prefix name                                                                                                                          | "TerraformAccount" |
|rosa_openshift_version| string      | The openshift cluster version                                                                                                                      | "4.12"             |
|ocm_environment| string      |  the OCM environments. The value should be one of those: production, staging, integration, local                                                                                                                                                  | "production"       |

## Usage

### Sample Usage

```
module "create_account_roles"{
   source = "terraform-redhat/rosa-sts/aws"
   version = "0.0.3"

   create_operator_roles = false
   create_oidc_provider = false
   create_account_roles = true

   account_role_prefix = var.account_role_prefix
   ocm_environment = var.ocm_environment
}
```

## The module uses the following resources
* aws_iam_role 
* aws_iam_policy 
* aws_iam_policy_attachment
