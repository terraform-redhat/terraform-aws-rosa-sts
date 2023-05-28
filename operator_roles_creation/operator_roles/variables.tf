variable cluster_id {
    description = "cluster ID"
    type = string
}

variable rh_oidc_provider_url {
    description = "oidc provider url"
    type = string
    default = "rh-oidc.s3.us-east-1.amazonaws.com"
}

variable permissions_boundary {
    description = "The ARN of the policy that is used to set the permissions boundary for the IAM roles in STS clusters."
    type = string
    default = ""
}

variable operator_role_properties {
    description = ""
    type = object({
        role_name = string
        policy_name = string
        service_accounts = list(string)
        operator_name = string
        operator_namespace = string
    })
}
