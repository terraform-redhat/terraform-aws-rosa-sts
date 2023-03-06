#!/bin/sh

export VERSION=$1
export DESTINATION_DIR_NAME="policies_v_"${VERSION}
export ACCOUNT_ROLES_DESTINATION_PATH=$(pwd)"/../account_roles_creation/account_role/"${DESTINATION_DIR_NAME}
echo " account roles destination path is ${ACCOUNT_ROLES_DESTINATION_PATH}"

export OPERATOR_ROLE_POLICY_DESTINATION_PATH=$(pwd)"/../account_roles_creation/operator_role_policy/"${DESTINATION_DIR_NAME}
echo " operator role policies destination path is ${OPERATOR_ROLE_POLICY_DESTINATION_PATH}"

mkdir -p ${ACCOUNT_ROLES_DESTINATION_PATH}
mkdir -p ${OPERATOR_ROLE_POLICY_DESTINATION_PATH}
cd ${ACCOUNT_ROLES_DESTINATION_PATH}

# In order to support hypershift needs to update the policy list
export FILE_NAMES=(
  "sts_installer_permission_policy.json"
  "sts_support_permission_policy.json"
  "sts_instance_controlplane_permission_policy.json"
  "sts_instance_worker_permission_policy.json"
)
for file_name in "${FILE_NAMES[@]}"; do
  file_path="https://raw.githubusercontent.com/openshift/managed-cluster-config/master/resources/sts/${VERSION}/${file_name}"
  echo "downloading file ${file_path}"
  curl -LJO ${file_path}
done

cd -
cd ${OPERATOR_ROLE_POLICY_DESTINATION_PATH}
#TODO: if there is a new policy for a new OCP versions, need to add it here also
export OPERATOR_POLICY_FILE_NAMES=(
    "openshift_cloud_network_config_controller_cloud_credentials_policy.json"
    "openshift_machine_api_aws_cloud_credentials_policy.json"
    "openshift_cloud_credential_operator_cloud_credential_operator_iam_ro_creds_policy.json"
    "openshift_image_registry_installer_cloud_credentials_policy.json"
    "openshift_ingress_operator_cloud_credentials_policy.json"
    "openshift_cluster_csi_drivers_ebs_cloud_credentials_policy.json"
)
for file_name in "${OPERATOR_POLICY_FILE_NAMES[@]}"; do
  file_path="https://raw.githubusercontent.com/openshift/managed-cluster-config/master/resources/sts/${VERSION}/${file_name}"
  echo "downloading file ${file_path}"
  curl -LJO ${file_path}
done