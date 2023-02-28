variable cluster_id {
    description = "cluster ID"
    type = string
    default = ""
}

variable rh_oidc_provider_url {
    description = "oidc provider url"
    type = string
    default = "rh-oidc.s3.us-east-1.amazonaws.com"
}

variable operator_roles_properties {
    description = "List of ROSA Operator IAM Roles"
    type = list(object({
        role_name = string
        policy_name = string
        service_accounts = list(string)
        operator_name = string
        operator_namespace = string
    }))
    default = []
}

variable create_operator_roles {
    description = "When using BYO OIDC and reusing the operator roles set to false so as not to create operator roles"
    type = bool
    default = false
}

variable create_oidc_provider {
    description = "When using BYO OIDC and reusing the OIDC provider set to false so as not to create identity provider"
    type = bool
    default = false
}

variable create_account_roles {
    description = "This attribute determines whether the module should create account roles or not"
    type = bool
    default = false
}

variable rh_oidc_provider_thumbprint {
    description = "Thumbprint for https://rh-oidc.s3.us-east-1.amazonaws.com"
    type = string
    default = "917e732d330f9a12404f73d8bea36948b929dffc"
}

variable account_role_prefix {
    type = string
    default = ""
}

variable rosa_openshift_version {
    type = string
    default = "4.12"
}


