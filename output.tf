output "secret_arn" {
  value = var.create_oidc_config_resources ? module.rosa_oidc_config_resources[0].secret_arn : null
}

