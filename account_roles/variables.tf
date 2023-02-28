variable account_role_prefix {
    type = string
}

variable account_role_properties {
    description = "Account IAM role properties"
    type = object({
            role_name = string
            role_type = string
            principal = string
            policy_file_name = string
        })
}

variable rosa_openshift_version {
    type = string
    default = "4.12"
}