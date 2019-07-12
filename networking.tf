resource "azurerm_virtual_network" "main" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.namespace}-vnet"
  address_space       = [var.network_cidr]
}

resource "azurerm_subnet" "main" {
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  name                 = "${var.namespace}-subnet"
  address_prefix       = var.network_cidr
}

# Utilize randomness to domain label
resource "random_pet" "main" {
  length = 2
}

resource "azurerm_public_ip" "main" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.namespace}-pubip"
  allocation_method   = "Static"
  domain_name_label   = "${var.namespace}-${random_pet.main.id}"
}

resource "azurerm_network_interface" "main" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.namespace}-nic"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.main.id
    public_ip_address_id          = azurerm_public_ip.main.id
    private_ip_address_allocation = "dynamic"
  }
}