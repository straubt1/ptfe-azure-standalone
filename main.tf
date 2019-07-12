terraform {
  required_version = "~> 0.12.4"

  required_providers {
    azurerm  = "~> 1.31"
    random   = "~> 2.1"
    tls      = "~> 2.0"
    local    = "~> 1.3"
    template = "~> 2.1"
    null     = "~> 2.1"
  }
}


resource "azurerm_resource_group" "main" {
  name     = "${var.namespace}-rg"
  location = var.location
}
