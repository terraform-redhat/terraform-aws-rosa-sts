# OIDC provider terraform module

Create rosa OIDC provider in a declarative way 
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
|rh_oidc_provider_thumbprint| string      | Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com                                                                                          | "2222222222222222222222222222222222222222"                                                                |
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

## Get OCM Information

When creating OIDC provider, the requirements are:
* cluster id
* OIDC endpoint url 
* thumbprint

## Usage

### Sample Usage

```
module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.4"

   create_operator_roles = false
   create_oidc_provider = true
   create_account_roles = false

    cluster_id = var.cluster_id
    rh_oidc_provider_thumbprint = var.oidc_thumbprint
    rh_oidc_provider_url = var.oidc_endpoint_url

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
* aws_iam_openid_connect_provider

## OIDC Configuration options

For Red Hat Managed or Customer Managed the client has extra configurations in the form of boolean attributes that indicate if creating the operator roles or OIDC provider is needed, the attributes are:

* create_operator_roles
* create_oidc_provider