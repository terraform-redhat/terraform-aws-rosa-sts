# Account roles terraform module

Create rosa account IAM roles in a declarative way
Terraform AWS ROSA STS


## Prerequisites
* OCM Account and OCM CLI
* terraform cli
* provider AWS - to get account details 

## Inputs
| Name | type        | Description                                                                                                                                                            | Example                                                                                                                                                                            |
|------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|account_role_prefix| string      | Account roles prefix name. If the value is empty, the module generates a string that starts with `account-role-` and concatenates it with a random string of length 4. | "TerraformAccount"                                                                                                                                                                 |
|path| string      | The arn path for the account/operator roles as well as their policies (optional)                                                                                       | "TerraformAccount"                                                                                                                                                                         |
|rosa_openshift_version| string      | The openshift cluster version                                                                                                                                          | "4.12"                                                                                                                                                                             |
|ocm_environment| string      | the OCM environments. The value should be one of those: production, staging, integration, local                                                                        | "production"                                                                                                                                                                       |
|permissions_boundary| string      | The ARN of the policy that is used to set the permissions boundary for the account roles in STS clusters.                                                              | "arn:aws:iam::123456789012:policy/XCompanyBoundaries"                                                                                                                                                                        |
|account_role_policies| object      | account role policies details for account roles creation                                                                                                               | [an example can be found below](https://github.com/terraform-redhat/terraform-aws-rosa-sts/tree/use_data_source_for_account_policies/account_roles_creation#account_role_policies-object) |
|operator_role_policies| object      | operator role policies details for operator role policies creation                                                                                                     | [an example can be found below](https://github.com/terraform-redhat/terraform-aws-rosa-sts/tree/use_data_source_for_account_policies/account_roles_creation#operator_role_policies-object) |
|tags | map of strings | List of AWS resource tags to apply                                                                                                                                     | [an example can be found below](#tags-object) |

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

### account_role_policies object
`account_role_policies` is an object that holds the policy details for each account role. 
This data can be extract by using the data source `ocm_policies` from terraform-provider-ocm
The object looks like: 
```
{
  "sts_installer_permission_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "sts_instance_controlplane_permission_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "sts_instance_worker_permission_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "sts_support_permission_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
}
```

### operator_role_policies object
`operator_role_policies` is an object that holds the policy details for each operator role.
The operator role policies are connected to a specific account role, so, they have been created as part of account roles creation.
This data can be extract by using the data source `ocm_policies` from terraform-provider-ocm
The object looks like:
```
{
  "openshift_cloud_credential_operator_cloud_credential_operator_iam_ro_creds_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "openshift_cloud_network_config_controller_cloud_credentials_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "openshift_cluster_csi_drivers_ebs_cloud_credentials_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "openshift_image_registry_installer_cloud_credentials_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "openshift_ingress_operator_cloud_credentials_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
  "openshift_machine_api_aws_cloud_credentials_policy" = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\",\"Action\": [], \"Resource\": \"*\"}]}"
}
```

## Usage

### Sample Usage

```
module "create_account_roles"{
  source = "terraform-redhat/rosa-sts/aws"
  version = ">=0.0.3"

  create_operator_roles = false
  create_oidc_provider = false
  create_account_roles = true

  account_role_prefix = var.account_role_prefix
  account_role_path = var.account_role_path
  ocm_environment = var.ocm_environment
  rosa_openshift_version = var.rosa_openshift_version
  account_role_policies = var.account_role_policies
  operator_role_policies = var.operator_role_policies

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
* aws_iam_role 
* aws_iam_policy 
* aws_iam_policy_attachment
