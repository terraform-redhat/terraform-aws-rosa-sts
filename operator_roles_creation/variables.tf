variable "cluster_id" {
  description = "cluster ID"
  type        = string
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
  validation {
    condition     = length(var.operator_roles_properties) == 6
    error_message = "The list of operator roles should contains 6 elements."
  }
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}
