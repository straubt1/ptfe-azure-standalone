# terraform {
#   required_providers = {
#     azurerm = "~> 1.31"
#     random  = "~> 2.1"
# * provider.tls: version = "~> 2.0"
# * provider.local: version = "~> 1.3"
# * provider.template: version = "~> 2.1"
#   }
# }

resource "azurerm_resource_group" "main" {
  name     = "${var.namespace}-rg"
  location = var.location
}


# provider "acme" {
#   // Production
#   server_url = "https://acme-v02.api.letsencrypt.org/directory"

#   // Staging
#   // server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
# }

# locals {
#   location       = "centralus"
#   rg_name        = "csg-terraform-enterprise"
#   name           = "csgtfe"
#   domain         = "tstraub.com"
#   admin_username = "csgadminuser"
# }

# // Keys


# resource "acme_registration" "main" {
#   account_key_pem = "${tls_private_key.ssl.private_key_pem}"
#   email_address   = "tstraub@cardinalsolutions.com"
# }

# resource "acme_certificate" "main" {
#   account_key_pem = "${acme_registration.main.account_key_pem}"
#   common_name     = "ptfe.${local.domain}"

#   dns_challenge {
#     provider = "azure"

#     config {
#       AZURE_RESOURCE_GROUP = "${azurerm_resource_group.main.name}"
#     }
#   }

#   provisioner "local-exec" {
#     command = "echo '${acme_certificate.main.certificate_pem}' > ../configuration/files/server.crt && echo '${acme_certificate.main.private_key_pem}' > ../configuration/files/server.key"
#   }
# }



# // DNS
# resource "azurerm_dns_zone" "main" {
#   resource_group_name = "${azurerm_resource_group.main.name}"
#   name                = "${local.domain}"
#   zone_type           = "Public"
# }

# resource "azurerm_dns_a_record" "main" {
#   resource_group_name = "${azurerm_resource_group.main.name}"
#   zone_name           = "${azurerm_dns_zone.main.name}"
#   name                = "ptfe"
#   ttl                 = 10
#   records             = ["${azurerm_public_ip.main.ip_address}"]
# }

# // Network




# resource "azurerm_virtual_machine" "main" {
#   resource_group_name = "${azurerm_resource_group.main.name}"
#   location            = "${azurerm_resource_group.main.location}"
#   name                = "${local.name}-vm${count.index}"

#   network_interface_ids = ["${element(azurerm_network_interface.main.*.id, count.index)}"]
#   vm_size               = "Standard_D2_v2"
#   count                 = 1

#   delete_os_disk_on_termination    = true
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "${local.name}vm${count.index}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#     disk_size_gb      = "128"
#   }

#   storage_data_disk {
#     create_option     = "Empty"
#     lun               = 0
#     name              = "${local.name}-vm-${count.index}_data0"
#     managed_disk_type = "Standard_LRS"
#     disk_size_gb      = "512"
#   }

#   os_profile {
#     computer_name  = "${local.name}vm${count.index}"
#     admin_username = "${local.admin_username}"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys {
#       path     = "/home/${local.admin_username}/.ssh/authorized_keys"
#       key_data = "${tls_private_key.main.public_key_openssh}"
#     }
#   }
# }
