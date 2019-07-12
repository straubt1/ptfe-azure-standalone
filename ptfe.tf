resource "tls_private_key" "main" {
  algorithm = "RSA"
}

// Not really needed, but nice to have the pem key if you want to SSH into the VM easily
resource "local_file" "main" {
  filename = "./.terraform/id_rsa_ptfe.pem"
  content  = tls_private_key.main.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 ./.terraform/id_rsa_ptfe.pem"
  }
}

resource "azurerm_virtual_machine" "main" {
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  name                             = "${var.namespace}-vm"
  network_interface_ids            = [azurerm_network_interface.main.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.namespace}vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "128"
  }

  # storage_data_disk {
  #   create_option     = "Empty"
  #   lun               = 0
  #   name              = "${local.name}-vm-${count.index}_data0"
  #   managed_disk_type = "Standard_LRS"
  #   disk_size_gb      = "512"
  # }

  os_profile {
    computer_name  = "${var.namespace}vm"
    admin_username = "${local.admin_username}"
    custom_data    = data.template_file.user-data.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${local.admin_username}/.ssh/authorized_keys"
      key_data = tls_private_key.main.public_key_openssh
    }
  }
}

# Isolate resource to wait for the health check to complete.
# This could be part of the VM resource, but isolating in case there is a failure
# which will keep the VM resource intact. 
resource "null_resource" "main" {
  depends_on = [azurerm_virtual_machine.main]
  provisioner "local-exec" {
    command = <<EOF
NOW=$(date +"%FT%T")
echo "[$NOW]  Sleeping for 5 minutes while PTFE installs."
sleep 300

while ! curl -ksfS --connect-timeout 5 https://${azurerm_public_ip.main.fqdn}/_health_check; do
    sleep 5
done
EOF
  }
}
