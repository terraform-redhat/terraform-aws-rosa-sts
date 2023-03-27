terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module rosa_operator_roles {
    source = "./operator_roles_creation"
    count = var.create_operator_roles ? 1 : 0

    cluster_id = var.cluster_id
    rh_oidc_provider_url = var.rh_oidc_provider_url
    operator_roles_properties = var.operator_roles_properties
}

module rosa_oidc_provider {
    source ="./oidc_provider_creation"
    count = var.create_oidc_provider ? 1:0

    rh_oidc_provider_url = var.rh_oidc_provider_url
    rh_oidc_provider_thumbprint = var.rh_oidc_provider_thumbprint
    cluster_id = var.cluster_id
}

module rosa_account_roles {
    source = "./account_roles_creation"
    count = var.create_account_roles ? 1 : 0

    account_role_prefix = var.account_role_prefix
    rosa_openshift_version = var.rosa_openshift_version
    ocm_environment = var.ocm_environment
    account_role_policies = var.account_role_policies
    operator_role_policies = var.operator_role_policies
}