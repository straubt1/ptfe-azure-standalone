output "ptfe-fqdn" {
  value = "https://${azurerm_public_ip.main.fqdn}"
}

output "ptfe-console-fqdn" {
  value = "https://${azurerm_public_ip.main.fqdn}:8800"
}

output "ptfe-vm-username" {
  value = local.admin_username
}

output "ptfe-console-password" {
  value = random_string.replicated-console-password.result
}

output "ptfe-site-admin-username" {
  value = var.ptfe_site_admin_username
}

output "ptfe-site-admin-password" {
  value = random_string.ptfe-siteadmin-password.result
}