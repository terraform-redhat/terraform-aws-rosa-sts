#!/bin/sh

export VERSION=$1
export DESTINATION_DIR_NAME="policies_v_"${VERSION}
export DESTINATION_PATH=$(pwd)"/../account_roles_creation/account_role/"${DESTINATION_DIR_NAME}
echo $DESTINATION_PATH

mkdir -p ${DESTINATION_PATH}
chmod +x ${DESTINATION_PATH}
cd ${DESTINATION_PATH}

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