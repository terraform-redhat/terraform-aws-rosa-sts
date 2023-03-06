resource "aws_iam_policy" "operator-policy" {
  name        = "${var.operator_role_policy_properties.policy_name}"
  policy = "${file("${path.module}/policies_v_${var.rosa_openshift_version}/${var.operator_role_policy_properties.policy_file_name}.json")}"

  tags = {
    rosa_openshift_version="${var.rosa_openshift_version}"
    rosa_role_prefix="${var.account_role_prefix}"
    operator_namespace="${var.operator_role_policy_properties.namespace}"
    operator_name="${var.operator_role_policy_properties.operator_name}"
  }
}
