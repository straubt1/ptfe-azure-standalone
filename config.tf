resource "random_string" "replicated-console-password" {
  length  = 24
  special = true
}

resource "random_string" "ptfe-encryption-password" {
  length  = 24
  special = true
}

resource "random_string" "ptfe-siteadmin-password" {
  length  = 24
  special = true
}

data "template_file" "replicated-config" {
  template = "${file("${path.module}/templates/replicated.conf.tpl")}"

  vars = {
    consolepassword = random_string.replicated-console-password.result
    domain          = azurerm_public_ip.main.fqdn
  }
}

data "template_file" "ptfe-config" {
  template = "${file("${path.module}/templates/settings.json.tpl")}"

  vars = {
    enc_password = random_string.ptfe-encryption-password.result
    domain       = azurerm_public_ip.main.fqdn
  }
}


data "template_file" "user-data" {
  template = "${file("${path.module}/templates/user-data.sh.tpl")}"

  vars = {
    tfe_config         = "${data.template_file.ptfe-config.rendered}"
    replicated_config  = "${data.template_file.replicated-config.rendered}"
    domain             = azurerm_public_ip.main.fqdn
    replicated_license = filebase64(var.ptfe_license_path)
    public_ip          = azurerm_public_ip.main.ip_address
    private_ip         = azurerm_network_interface.main.private_ip_address
    tfe_username       = var.ptfe_site_admin_username
    tfe_email          = var.ptfe_site_admin_email
    tfe_password       = random_string.ptfe-siteadmin-password.result
  }
}

# local files for debugging, not needed
resource "local_file" "replicated-config" {
  filename = "./.terraform/replicated.conf"
  content  = data.template_file.replicated-config.rendered
}
resource "local_file" "ptfe-config" {
  filename = "./.terraform/settings.json"
  content  = data.template_file.ptfe-config.rendered
}
resource "local_file" "user-data" {
  filename = "./.terraform/user-data.sh"
  content  = data.template_file.user-data.rendered
}