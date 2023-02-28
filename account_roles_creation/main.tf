terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module rosa_account_roles {
    source = "./account_role"
    count = 2

    account_role_prefix = var.account_role_prefix
    rosa_openshift_version = var.rosa_openshift_version
    account_role_properties = local.account_roles_properties[count.index]
    instance_account_role_properties = local.instance_account_roles_properties[count.index]
    account_id = lookup({"production"="710019948333", "staging"="644306948063", "integration"="896164604406", "local"="765374464689"}, var.ocm_environment, "710019948333")
}

locals {
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
    }]

    instance_account_roles_properties = [{
       # worker
       role_name = "Worker"
       role_type = "worker"
       policy_file_name = "sts_instance_worker_permission_policy"
    },
    {
       # control plan
       role_name = "ControlPlane"
       role_type = "controlplane"
       policy_file_name = "sts_instance_controlplane_permission_policy"
    }]
}