variable "account_role_prefix" {
  type    = string
  default = ""
}

variable "rosa_openshift_version" {
  type    = string
  default = "4.12"
}

variable "ocm_environment" {
  description = "the OCM environments. The value should be one of those: production, staging, integration, local"
  type        = string
  validation {
    condition = anytrue([
      var.ocm_environment == "production",
      var.ocm_environment == "staging",
      var.ocm_environment == "integration",
      var.ocm_environment == "local",
    ])
    error_message = "The OCM environment value should be one of those: production, staging, integration, local."
  }
}

variable "account_role_policies" {
  description = "account role policies details for account roles creation"
  type = object({
    sts_installer_permission_policy             = string
    sts_support_permission_policy               = string
    sts_instance_worker_permission_policy       = string
    sts_instance_controlplane_permission_policy = string
  })
}

variable "operator_role_policies" {
  description = "operator role policies details for operator roles creation"
  type = object({
    openshift_cloud_credential_operator_cloud_credential_operator_iam_ro_creds_policy = string
    openshift_cloud_network_config_controller_cloud_credentials_policy                = string
    openshift_cluster_csi_drivers_ebs_cloud_credentials_policy                        = string
    openshift_image_registry_installer_cloud_credentials_policy                       = string
    openshift_ingress_operator_cloud_credentials_policy                               = string
    shared_vpc_openshift_ingress_operator_cloud_credentials_policy                    = string
    openshift_machine_api_aws_cloud_credentials_policy                                = string
  })
}

variable "shared_vpc_role_arn" {
  description = "The role ARN used to access the private hosted zone, in case shared VPC is used"
  type        = string
  default     = ""
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM roles in STS clusters."
  type        = string
  default     = ""
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}
