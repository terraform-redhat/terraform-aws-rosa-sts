# ROSA STS terraform module

Create rosa operator IAM roles in a declarative way
Terraform AWS ROSA STS

## Prerequisites

* AWS Admin Account configured by using AWS CLI in AWS configuration file
* OCM Account and OCM CLI
* ROSA STS cluster
* terraform cli
* provider AWS - to get account details
* provider OCM - to get cluster operator role properties, and information to create OIDC provider. 

## Inputs
| Name | type        | Description                                                                                                                                        | Example                                                                                                   |
|------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
|cluster_id| string      | Cluster ID                                                                                                                                         | "11111111111111111111111111111111"                                                                        |
|rh_oidc_provider_url| string      | OIDC provider url                                                                                                                                  | "rh-oidc-staging.s3.us-east-1.amazonaws.com/11111111111111111111111111111111"                             |
|permissions_boundary| string      | The ARN of the policy that is used to set the permissions boundary for the operator roles in STS clusters.                                         | "arn:aws:iam::123456789012:policy/XCompanyBoundaries"                                                                                                                                                                        |
|operator_roles_properties| list of map | List of 6 items of ROSA Operator IAM Roles. Each item should contains: role_name, policy_name, service_accounts, operator_name, operator_namespace | can be found [below](https://github.com/terraform-redhat/terraform-aws-rosa-sts#get-clusters-information) |
|path| string      | The arn path for the account/operator roles as well as their policies (optional)                                                                                                                          | "TerraformAccount"                                                                                                                                                                         |
|tags | map of strings |List of AWS resource tags to apply | [an example can be found below](#tags-object) |

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

## Get OCM Information

When creating operator IAM roles and OIDC provider, the requirements are:
* cluster id
* operator role prefix
* OIDC endpoint url 

## Usage

### Sample Usage

```
data "ocm_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix = var.account_role_prefix
}

module operator_roles {
   source = "terraform-redhat/rosa-sts/aws"
   version = "0.0.4"

   create_operator_roles = true
   create_oidc_provider = false
   create_account_roles = false

    cluster_id = ocm_cluster_rosa_classic.rosa_sts_cluster.id
    rh_oidc_provider_url = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
    operator_roles_properties = data.ocm_rosa_operator_roles.operator_roles.operator_iam_roles
   path = var.path

    #optional
    tags                = {
      contact     = "xyz@company.com"
      cost-center = "12345"
      owner       = "productteam"
      environment = "test"
    }
}
```

## The module uses the following resources
* aws_caller_identity (resource)
* aws_iam_role_policy_attachment (resource)
* aws_caller_identity (data source)
