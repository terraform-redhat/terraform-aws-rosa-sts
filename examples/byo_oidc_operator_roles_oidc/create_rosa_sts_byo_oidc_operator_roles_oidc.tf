terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
    ocm = {
      version = "0.0.1"
      source  = "terraform-redhat/ocm"
    }
  }
}

provider "ocm" {
  token = var.token
  url = var.url
}

data "ocm_rosa_operator_roles" "rosa_sts" {
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix = var.account_role_prefix
}

module rosa_sts {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.1"

    cluster_id = var.cluster_id
    rh_oidc_provider_thumbprint = var.oidc_thumbprint
    rh_oidc_provider_url = var.oidc_endpoint_url
    create_operator_roles = var.create_operator_roles
    create_oidc_provider = var.create_oidc_provider

    operator_roles_properties = data.ocm_rosa_operator_roles.rosa_sts.operator_iam_roles
}
