variable account_role_prefix {
    type = string
    default = ""
}

variable rosa_openshift_version {
    type = string
    default = "4.12"
}

variable ocm_environment {
    description = "The OCM environment. Should be one of those: production, staging, integration, local"
    type = string
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


