# ROSA STS terraform module

Create rosa account IAM roles, operator IAM roles and OIDC provider in a declarative way
Terraform AWS ROSA STS

In order to deploy [ROSA](https://docs.openshift.com/rosa/welcome/index.html) with [STS](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html), AWS Account needs to have the following roles placed:

* Account Roles (One per AWS account)
* Operator Roles (One Per Cluster)
* OIDC Identity Provider (One Per Cluster)

This terraform module tries to replicate rosa CLI roles creation so that:

* Users have a declarative way to create AWS roles and OIDC provider.
* Users can implement security/infrastructure as code practices.
* Batch creation of operator roles and OIDC provider.

## Prerequisites

* AWS Admin Account configured by using AWS CLI in AWS configuration file
* OCM Account and OCM CLI
* ROSA STS cluster
* terraform cli
* provider AWS - to get account details
* provider [RHCS](https://github.com/terraform-redhat/terraform-provider-rhcs) - to get cluster operator role properties, and information to create OIDC provider. 

## Inputs
| Name                         | type           | Description                                                                                                                                        | Example                                                                                                                                                                                    |
|------------------------------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cluster_id                   | string         | Cluster ID                                                                                                                                         | "11111111111111111111111111111111"                                                                                                                                                         |
| permissions_boundary         | string         | The ARN of the policy that is used to set the permissions boundary for the IAM roles in STS clusters. | "arn:aws:iam::123456789012:policy/RoleBoundaries"                                                                                                                                          |
| rh_oidc_provider_url         | string         | OIDC provider url                                                                                                                                  | "rh-oidc-staging.s3.us-east-1.amazonaws.com/11111111111111111111111111111111"                                                                                                              |
| tags                         | map of strings |List of AWS resource tags to apply | [an example can be found below](#tags-object)                                                                                                                                              |
| operator_roles_properties    | list of map    | List of 6 items of ROSA Operator IAM Roles. Each item should contains: role_name, policy_name, service_accounts, operator_name, operator_namespace | can be found [below](https://github.com/terraform-redhat/terraform-aws-rosa-sts#get-clusters-information)                                                                                  |
| create_operator_roles        | bool           | Indicates if operator roles creation is needed                                                                                                     | true)                                                                                                                                                                                      |
| create_oidc_provider         | bool           | Indicates if oidc provider creation is needed                                                                                                      | true)                                                                                                                                                                                      |
| create_account_roles         | bool           | Indicates if account roles creation is needed                                                                                                      | true)                                                                                                                                                                                      |
| rh_oidc_provider_thumbprint  | string         | Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com                                                                                          | "2222222222222222222222222222222222222222"                                                                                                                                                 |
| account_role_prefix          | string         | Account roles prefix name. If the value is empty, the module generates a string that starts with `account-role-` and concatenates it with a random string of length 4. | "TerraformAccount"                                                                                                                                                                         | "TerraformAccount"                                                                                                                                                                         |
| path                         | string         | The arn path for the account/operator roles as well as their policies (optional)                                                                                                                          | "TerraformAccount"                                                                                                                                                                         |
| rosa_openshift_version       | string         | The openshift cluster version                                                                                                                      | "4.12"                                                                                                                                                                                     |
| ocm_environment              | string         | the OCM environments. The value should be one of those: production, staging, integration, local                                                    | "production"                                                                                                                                                                               |
| account_role_policies        | object         | account role policies details for account roles creation                                                                                           | [an example can be found below](https://github.com/terraform-redhat/terraform-aws-rosa-sts/tree/use_data_source_for_account_policies/account_roles_creation#account_role_policies-object)  |
| all_versions                 | object         | OpenShift versions                                                                                           | [an output of the data source `rhcs_versions`](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/data-sources/versions)                                            |
| operator_role_policies       | object         | operator role policies details for operator role policies creation                                                                                 | [an example can be found below](https://github.com/terraform-redhat/terraform-aws-rosa-sts/tree/use_data_source_for_account_policies/account_roles_creation#operator_role_policies-object) |
| create_oidc_config_resources | string         | The S3 bucket name                                                                                                                                 | "oidc-f3y4"                                                                                                                                                                                |
| bucket_name                  | string         | The S3 bucket name                                                                                                                                 | "oidc-f3y4"                                                                                                                                                                                |
| discovery_doc                | string         | The discovery document string file                                                                                                                 |                                                                                                                                                                                            |
| jwks                         | string         | Json web key set string file                                                                                                                       |                                                                                                                                                                                            |
| private_key                  | string         | RSA private key                                                                                                                                    |                                                                                                                                                                                            |
| private_key_file_name        | string         | The private key file name                                                                                                                          | "rosa-private-key-oidc-f3y4.key"                                                                                                                                                           |
| private_key_secret_name      |  string        | The secret name that store the private key                                                                                                         | "rosa-private-key-oidc-f3y4"                                                                                                                                                               |

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

## Get OCM Information for operator roles and OIDC provider

When creating operator IAM roles and OIDC provider, the requirements are:
* cluster id
* operator role prefix
* OIDC endpoint url 
* thumbprint


The information can be retrieved by using the [Red Hat Cloud Services Provider](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest) 

## Get Clusters Information.

In order to create operator roles for clusters.
Users need to provide cluster id, OIDC Endpoint URL and thumbprint and operator roles properties list.

```
 rosa describe cluster -c shaozhenprivate -o json
{
  "kind": "Cluster",
  "id": "1srtno3qggal8ujsegvtb2njvbmhdu8c",
  "href": "/api/clusters_mgmt/v1/clusters/1srtno3qggal8ujsegvtb2njvbmhdu8c",
  "aws": {
    "sts": {
      "oidc_endpoint_url": "https://rh-oidc.s3.us-east-1.amazonaws.com/1srtno3qggal8ujsegvtb2njvbmhdu8c",
      "operator_iam_roles": [
        {
          "id": "",
          "name": "ebs-cloud-credentials",
          "namespace": "openshift-cluster-csi-drivers",
          "role_arn": "arn:aws:iam::${AWS_ACCOUNT_ID}:role/shaozhenprivate-w4e1-openshift-cluster-csi-drivers-ebs-cloud-cre",
          "service_account": ""
        },
```

In the above example:

* cluster_id =  1srtno3qggal8ujsegvtb2njvbmhdu8c
* operator_role_prefix = shaozhenprivate-w4e1
* account_role_prefix = ManagedOpenShift
* rh_oidc_endpoint_url = rh-oidc.s3.us-east-1.amazonaws.com
* thumbprint - calculated 


The operator roles properties variable is the output of the data source `ocm_rosa_operator_roles` and it's a list of 6 maps which looks like:
```
operator_iam_roles = [
  {
    "operator_name" = "cloud-credentials"
    "operator_namespace" = "openshift-ingress-operator"
    "policy_name" = "ManagedOpenShift-openshift-ingress-operator-cloud-credentials"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-ingress-operator-cloud-credentials"
    "role_name" = "terrafom-operator-openshift-ingress-operator-cloud-credentials"
    "service_accounts" = [
      "system:serviceaccount:openshift-ingress-operator:ingress-operator",
    ]
  },
  {
    "operator_name" = "ebs-cloud-credentials"
    "operator_namespace" = "openshift-cluster-csi-drivers"
    "policy_name" = "ManagedOpenShift-openshift-cluster-csi-drivers-ebs-cloud-credent"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-cluster-csi-drivers-ebs-cloud-creden"
    "role_name" = "terrafom-operator-openshift-cluster-csi-drivers-ebs-cloud-creden"
    "service_accounts" = [
      "system:serviceaccount:openshift-cluster-csi-drivers:aws-ebs-csi-driver-operator",
      "system:serviceaccount:openshift-cluster-csi-drivers:aws-ebs-csi-driver-controller-sa",
    ]
  },
  {
    "operator_name" = "cloud-credentials"
    "operator_namespace" = "openshift-cloud-network-config-controller"
    "policy_name" = "ManagedOpenShift-openshift-cloud-network-config-controller-cloud"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-cloud-network-config-controller-clou"
    "role_name" = "terrafom-operator-openshift-cloud-network-config-controller-clou"
    "service_accounts" = [
      "system:serviceaccount:openshift-cloud-network-config-controller:cloud-network-config-controller",
    ]
  },
  {
    "operator_name" = "aws-cloud-credentials"
    "operator_namespace" = "openshift-machine-api"
    "policy_name" = "ManagedOpenShift-openshift-machine-api-aws-cloud-credentials"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-machine-api-aws-cloud-credentials"
    "role_name" = "terrafom-operator-openshift-machine-api-aws-cloud-credentials"
    "service_accounts" = [
      "system:serviceaccount:openshift-machine-api:machine-api-controllers",
    ]
  },
  {
    "operator_name" = "cloud-credential-operator-iam-ro-creds"
    "operator_namespace" = "openshift-cloud-credential-operator"
    "policy_name" = "ManagedOpenShift-openshift-cloud-credential-operator-cloud-crede"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-cloud-credential-operator-cloud-cred"
    "role_name" = "terrafom-operator-openshift-cloud-credential-operator-cloud-cred"
    "service_accounts" = [
      "system:serviceaccount:openshift-cloud-credential-operator:cloud-credential-operator",
    ]
  },
  {
    "operator_name" = "installer-cloud-credentials"
    "operator_namespace" = "openshift-image-registry"
    "policy_name" = "ManagedOpenShift-openshift-image-registry-installer-cloud-creden"
    "role_arn" = "arn:aws:iam::765374464689:role/terrafom-operator-openshift-image-registry-installer-cloud-crede"
    "role_name" = "terrafom-operator-openshift-image-registry-installer-cloud-crede"
    "service_accounts" = [
      "system:serviceaccount:openshift-image-registry:cluster-image-registry-operator",
      "system:serviceaccount:openshift-image-registry:registry",
    ]
  },
]

```
## Usage

### Sample Usage for account IAM roles

```
module "create_account_roles"{
   source = "terraform-redhat/rosa-sts/aws"
   version = "0.0.5"

   create_account_roles = true

   account_role_prefix      = var.account_role_prefix
   path                     = var.path
   ocm_environment          = var.ocm_environment
   rosa_openshift_version   = var.rosa_openshift_version
   account_role_policies    = var.account_role_policies
   all_versions             = var.all_versions
   operator_role_policies   = var.operator_role_policies

    #optional
    tags                    = {
      contact     = "xyz@company.com"
      cost-center = "12345"
      owner       = "productteam"
      environment = "test"
    }
}
```

### Sample Usage for operator IAM roles and OIDC provider

```
data "rhcs_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix = var.account_role_prefix
}

module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.5"
    
    create_operator_roles = true
    create_oidc_provider = true

    cluster_id = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
    rh_oidc_provider_thumbprint = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
    rh_oidc_provider_url = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
    operator_roles_properties = data.rhcs_rosa_operator_roles.operator_roles.operator_iam_roles

    #optional
    tags                = {
      contact     = "xyz@company.com"
      cost-center = "12345"
      owner       = "productteam"
      environment = "test"
    }
}
```

### Sample Usage for OIDC config resources

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
* aws_iam_openid_connect_provider (resource)
* aws_iam_policy (resource)
* aws_iam_role (resource)
* aws_iam_role_policy_attachment (resource)
* aws_caller_identity (data source)
* aws_s3_bucket (resource)
* aws_s3_bucket_public_access_block (resource)
* aws_s3_bucket_policy (resource)
* aws_iam_policy_document (resource)
* aws_secretsmanager_secret (resource)
* aws_secretsmanager_secret_version (resource)
* aws_s3_object (resource)

## OIDC Configuration options

For Red Hat Managed or Customer Managed the client has extra configurations in the form of boolean attributes that indicate if creating the operator roles or OIDC provider is needed, the attributes are:

* create_operator_roles
* create_oidc_provider
