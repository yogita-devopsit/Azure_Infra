# Azure Infrastructure with Terraform

This project provisions a small Microsoft Azure environment using Terraform and reusable child modules.

The example configuration creates:

- One resource group in `East Asia`
- One virtual network with address space `10.0.0.0/16`
- One subnet with address range `10.0.1.0/24`
- One Standard, static public IP address
- One Ubuntu Server 22.04 virtual machine
- One network interface connecting the VM to the subnet and public IP

## Architecture

The root configuration is in the `environment` directory. It calls the child modules in this order:

```text
resource group
	|
	+-- virtual network
			|
			+-- subnet -- virtual machine -- network interface -- public IP
```

The VM module reads the subnet and public IP using Azure data sources. The `depends_on` settings in `environment/main.tf` ensure the resource group, virtual network, and subnet are created before dependent modules run.

## Repository structure

```text
Azure_Infra/
|-- child_module/
|   |-- public_ip/
|   |-- resource_group/
|   |-- subnet/
|   |-- virtual_machine/
|   `-- virtual_network/
|-- environment/
|   |-- main.tf          # Root module composition
|   |-- provider.tf      # Terraform and AzureRM provider versions
|   |-- terraform.tfvars # Example environment values
|   `-- variable.tf      # Root module inputs
`-- README.md
```

## Prerequisites

- Terraform `1.5.0` or later
- An Azure subscription
- Azure CLI installed and authenticated, or another supported AzureRM authentication method
- Permission to create resource groups, networking resources, public IPs, NICs, and virtual machines

The configuration uses the `hashicorp/azurerm` provider version `4.x`.

Authenticate with Azure CLI before running Terraform:

```bash
az login
az account set --subscription "<subscription-id-or-name>"
```

## Usage

Run Terraform from the `environment` directory:

```bash
cd environment
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

When the infrastructure is no longer needed, destroy it from the same directory:

```bash
terraform destroy
```

## Configuration

The example values are stored in `environment/terraform.tfvars`. The root module accepts these five map-style inputs:

| Variable | Purpose |
| --- | --- |
| `resource_group` | Resource group names and locations |
| `virtual_network` | Virtual network names, address spaces, and resource groups |
| `subnet` | Subnet names, address prefixes, and parent virtual networks |
| `pip` | Public IP names, locations, allocation methods, and SKUs |
| `vms` | VM, NIC, subnet, public IP, and network details |

Each child module uses `for_each`, so additional resources can be added by adding entries to the corresponding map. Names must match across the maps. For example, the VM entry refers to the public IP using `pip_name` and to the subnet using `subnet_name` and `virtual_network_name`.

## Security notes

- Do not commit real secrets in `.tfvars` files. The repository's `.gitignore` currently has the Terraform variable-file patterns commented out, so enable `*.tfvars` and `*.tfvars.json` before adding sensitive values.
- The VM module currently contains a hardcoded administrator username and password. Replace these with sensitive variables, SSH key authentication, or Azure Key Vault before using this configuration beyond testing.
- Terraform state can contain sensitive infrastructure data. Keep state in a protected backend for shared or production use.

## Current limitations

- There are no outputs defined, so Terraform does not currently print the VM or public IP address after deployment.
- Most variables use `type = any`; adding explicit object types and validation would catch mismatched names and values earlier.
- The VM uses the legacy `azurerm_virtual_machine` resource and a fixed VM size, disk name, hostname, and operating system image.
