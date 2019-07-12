output "ptfe-fqdn" {
  description = "The full URL to the pTFE instance."
  value       = "https://${azurerm_public_ip.main.fqdn}"
}

output "ptfe-console-fqdn" {
  description = "The full URL of the replicated console."
  value       = "https://${azurerm_public_ip.main.fqdn}:8800"
}

output "ptfe-vm-username" {
  description = "The admin username for the VM. Needed to SSH into the instance."
  value       = local.admin_username
}

output "ptfe-console-password" {
  description = "The password for the replicated console. Dynamically generated."
  value       = random_string.replicated-console-password.result
}

output "ptfe-site-admin-username" {
  description = "The username for the site admin. User provided."
  value       = var.ptfe_site_admin_username
}

output "ptfe-site-admin-password" {
  description = "The password for the site admin. Dynamically generated."
  value       = random_string.ptfe-siteadmin-password.result
}