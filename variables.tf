variable "cluster_id" {
  description = "cluster ID"
  type        = string
  default     = ""
}

variable "rh_oidc_provider_url" {
  description = "oidc provider url"
  type        = string
  default     = "rh-oidc.s3.us-east-1.amazonaws.com"
}

variable "operator_roles_properties" {
  description = "List of ROSA Operator IAM Roles"
  type = list(object({
    role_name          = string
    policy_name        = string
    service_accounts   = list(string)
    operator_name      = string
    operator_namespace = string
  }))
  default = []
}

variable "create_operator_roles" {
  description = "When using BYO OIDC and reusing the operator roles set to false so as not to create operator roles"
  type        = bool
}

variable "create_oidc_provider" {
  description = "When using BYO OIDC and reusing the OIDC provider set to false so as not to create identity provider"
  type        = bool
}

variable "create_account_roles" {
  description = "This attribute determines whether the module should create account roles or not"
  type        = bool
}

variable "rh_oidc_provider_thumbprint" {
  description = "Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com"
  type        = string
  default     = "917e732d330f9a12404f73d8bea36948b929dffc"
}

variable "account_role_prefix" {
  type    = string
  default = ""
}

variable "rosa_openshift_version" {
  type    = string
  default = "4.12"
}

variable "ocm_environment" {
  description = "The OCM environments should be one of those: production, staging, integration, local"
  type        = string
  default     = ""
}

variable "account_role_policies" {
  description = "account role policies details for account roles creation"
  type = object({
    sts_installer_permission_policy             = string
    sts_support_permission_policy               = string
    sts_instance_worker_permission_policy       = string
    sts_instance_controlplane_permission_policy = string
  })
  default = null
}

variable "operator_role_policies" {
  description = "operator role policies details for operator roles creation"
  type = object({
    openshift_cloud_credential_operator_cloud_credential_operator_iam_ro_creds_policy = string
    openshift_cloud_network_config_controller_cloud_credentials_policy                = string
    openshift_cluster_csi_drivers_ebs_cloud_credentials_policy                        = string
    openshift_image_registry_installer_cloud_credentials_policy                       = string
    openshift_ingress_operator_cloud_credentials_policy                               = string
    openshift_machine_api_aws_cloud_credentials_policy                                = string
  })
  default = null
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}