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
    count = var.create_operator_roles ? 6 : 0

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

module rosa_account_roles {
    source = "./account_roles"
    count = var.create_account_roles ? 4 : 0

    account_role_prefix = var.account_role_prefix
    rosa_openshift_version = var.rosa_openshift_version
    account_role_properties = local.account_roles_properties[count.index]
}

locals ={
    account_roles_properties = [{
        # installer
        role_name = "Installer"
        role_type = "installer"
        principal = "RH-Managed-OpenShift-Installer"
        policy_file_name = "sts_installer_permission_policy"
    },
    {
       # support
       role_name = "Support"
       role_type = "support"
       principal = "RH-Technical-Support-Access"
       policy_file_name = "sts_support_permission_policy"
    },
    {
       # worker
       role_name = "Worker"
       role_type = "worker"
       principal = ""
       policy_file_name = "sts_instance_worker_permission_policy"
    },
    {
       # control plan
       role_name = "ControlPlane"
       role_type = "controlplane"
       principal = ""
       policy_file_name = "sts_instance_controlplane_permission_policy"
    }]
}