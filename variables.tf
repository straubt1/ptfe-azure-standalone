locals {
  admin_username = "ptfepoweruser"
}

variable "ptfe_license_path" {
  description = "The full path to the pTFE license file."
}

variable "ptfe_site_admin_username" {
  description = "The PTFE site administrator username."
}

variable "ptfe_site_admin_email" {
  description = "The PTFE site administrator email."
}

variable "namespace" {
  description = "Name to assign to resources for easy organization"
  default     = "ptfe"
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
  default     = "centralus"
}

variable "network_cidr" {
  description = "The network address CIDR for the Vnet/Subnet."
  default     = "10.0.0.0/24"
}

variable "vm_size" {
  description = "The VM size to create."
  default     = "Standard_D2_v2"
}
