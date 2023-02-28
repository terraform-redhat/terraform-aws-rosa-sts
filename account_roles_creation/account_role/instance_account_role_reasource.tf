# role
resource "aws_iam_role" "instance_account_role" {
  name = "${var.account_role_prefix}-${var.instance_account_role_properties.role_name}-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      },
    ]
  })

  tags = {
    rosa_openshift_version = var.rosa_openshift_version
    rosa_role_prefix = "${var.account_role_prefix}"
    rosa_role_type = "instance_${var.instance_account_role_properties.role_type}"
  }
}

# policy
resource "aws_iam_policy" "instance_account_role_policy" {
  name        = "${var.account_role_prefix}-${var.instance_account_role_properties.role_name}-Role-Policy"
  policy = "${file("${path.module}/policies_v_${var.rosa_openshift_version}/${var.instance_account_role_properties.policy_file_name}.json")}"
  tags = {
    rosa_openshift_version = var.rosa_openshift_version
    rosa_role_prefix = "${var.account_role_prefix}"
    rosa_role_type = "instance_${var.instance_account_role_properties.role_type}"
  }
}


# policy attachment
resource "aws_iam_policy_attachment" "instance_role_policy_attachment" {
  name       = "${var.instance_account_role_properties.role_type}-role-policy-attachment"
  roles      = [aws_iam_role.instance_account_role.name]
  policy_arn = aws_iam_policy.instance_account_role_policy.arn
}
