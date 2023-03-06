terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module rosa_operator_roles {
    source = "./operator_roles"
    count = var.create_operator_roles ? (var.is_hosted_cp ? 10 : 6) : 0

    cluster_id = var.cluster_id
    rh_oidc_provider_url = var.rh_oidc_provider_url
    operator_role_properties = var.operator_roles_properties[count.index]
}

module rosa_oidc_provider {
    source ="./oidc_provider"
    count = var.create_oidc_provider ? 1:0

    rh_oidc_provider_url = var.rh_oidc_provider_url
    rh_oidc_provider_thumbprint = var.rh_oidc_provider_thumbprint
    cluster_id = var.cluster_id
}
