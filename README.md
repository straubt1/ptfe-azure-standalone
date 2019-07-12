# ptfe-azure-standalone

## Networking

Single VNet with a single subnet.

## Compute

Single Virtual Machine running Ubuntu 16.04

## Running

1. Clone this repository
2. Create a `terraform.tfvars` file and fill in the following values. The license path will be the path the license.rli file for pTFE.

```hcl
ptfe_license_path        = ""
ptfe_site_admin_username = ""
ptfe_site_admin_email    = ""
```
3. Apply the Terraform.
> Note: it may take up to 10 minutes for the TFE instance to become available after the Terraform Apply completes.
4. Grab the output values.
These will look something like this:
```sh
ptfe-console-fqdn = https://ptfe-<random pet domain>.centralus.cloudapp.azure.com:8800
ptfe-console-password = <random generated password>
ptfe-fqdn = https://ptfe-<random pet domain>.centralus.cloudapp.azure.com
ptfe-site-admin-password = <random generated password>
ptfe-site-admin-username = <user provided>
ptfe-vm-username = ptfepoweruser
```
Navigate to the `ptfe-fqdn` from a browser (accept the self-signed cert error), you will see a login.
Use the site admin credentials to gain access to Terraform Enterprise.

## Accessing the Terraform console

The `terraform output` will give the `ptfe-console-fqdn` and `ptfe-console-password`.
Navigate to the endpoint from a browser and use the console password to unlock.

## Accessing the underlying instance

The `terraform output` will give the `ptfe-vm-username` needed, and the ssh private key can be found at `.terraform/id_rsa_ptfe.pem`. Using both of these, you can SSH into the public endpoint.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| location | The Azure region to deploy all infrastructure to. | string | `"centralus"` | no |
| namespace | Name to assign to resources for easy organization | string | `"ptfe"` | no |
| network\_cidr | The network address CIDR for the Vnet/Subnet. | string | `"10.0.0.0/24"` | no |
| ptfe\_license\_path | The full path to the pTFE license file. | string | n/a | yes |
| ptfe\_site\_admin\_email | The PTFE site administrator email. | string | n/a | yes |
| ptfe\_site\_admin\_username | The PTFE site administrator username. | string | n/a | yes |
| vm\_size | The VM size to create. | string | `"Standard_D2_v2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ptfe-console-fqdn |  |
| ptfe-console-password |  |
| ptfe-fqdn |  |
| ptfe-site-admin-password |  |
| ptfe-site-admin-username |  |
| ptfe-vm-username |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->