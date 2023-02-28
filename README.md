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
* provider OCM - to get cluster operator role properties, and information to create OIDC provider. 

## Inputs
| Name | type        | Description                                                                                                                                        | Example                                                                                                   |
|------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
|cluster_id| string      | Cluster ID                                                                                                                                         | "11111111111111111111111111111111"                                                                        |
|rh_oidc_provider_url| string      | OIDC provider url                                                                                                                                  | "rh-oidc-staging.s3.us-east-1.amazonaws.com/11111111111111111111111111111111"                             |
|rh_oidc_provider_thumbprint| string      | Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com                                                                                          | "2222222222222222222222222222222222222222"                                                                |
|operator_roles_properties| list of map | List of 6 items of ROSA Operator IAM Roles. Each item should contains: role_name, policy_name, service_accounts, operator_name, operator_namespace | can be found [below](https://github.com/terraform-redhat/terraform-aws-rosa-sts#get-clusters-information) |
|account_role_prefix| string      | Account roles prefix name                                                                                                                          | "TerraformAccount" |
|rosa_openshift_version| string      | The openshift cluster version                                                                                                                      | "4.12"             |
|ocm_environment| string      |  the OCM environments. The value should be one of those: production, staging, integration, local                                                                                                                                                  | "production"       |


## Get OCM Information for operator roles and OIDC provider

When creating operator IAM roles and OIDC provider, the requirements are:
* cluster id
* operator role prefix
* OIDC endpoint url 
* thumbprint


The information can be retrieved by using the [OCM provider](https://registry.terraform.io/providers/terraform-redhat/ocm/latest) 

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
   version = "0.0.3"

   create_operator_roles = false
   create_oidc_provider = false
   create_account_roles = true

   account_role_prefix = var.account_role_prefix
   ocm_environment = var.ocm_environment
}
```

### Sample Usage for operator IAM roles and OIDC provider

```
data "ocm_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix = var.account_role_prefix
}

module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.3"
    
    create_operator_roles = true
    create_oidc_provider = true
    create_account_roles = false

    cluster_id = ocm_cluster_rosa_classic.rosa_sts_cluster.id
    rh_oidc_provider_thumbprint = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
    rh_oidc_provider_url = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
    operator_roles_properties = data.ocm_rosa_operator_roles.operator_roles.operator_iam_roles
}
```

## The module uses the following resources
* aws_iam_openid_connect_provider (resource)
* aws_iam_policy (resource)
* aws_iam_role (resource)
* aws_iam_role_policy_attachment (resource)
* aws_caller_identity (data source)

## BYO OIDC options

For BYO OIDC the client has extra configurations in the form of boolean attributes that indicate if creating the operator roles or OIDC provider is needed, the attributes are:

* create_operator_roles
* create_oidc_provider