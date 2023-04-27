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
    openshift_machine_api_aws_cloud_credentials_policy                                = string
  })
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}
