<!-- BEGIN_TF_DOCS -->
# Deploys Private Link DNS Zones to multiple regions and link with their own vNets

This deploys the in a more advanced configuration and also allows a scale test.

It will deploy all known Azure Private DNS Zones for Azure Services that support Private Link into an existing Resource Group and will also link each of the Private DNS Zones to the Virtual Networks provided via a Private DNS Zone Virtual Network Link for 2 regions.

```hcl
terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {}

# Region 1
module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

resource "random_integer" "region_index_1" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming_1" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "region_1" {
  location = module.regions.regions[random_integer.region_index_1.result].name
  name     = module.naming_1.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_1" {
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.region_1.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.region_1.name
}

module "test_region_1" {
  source = "../../"
  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"

  location            = azurerm_resource_group.region_1.location
  resource_group_name = azurerm_resource_group.region_1.name

  resource_group_creation_enabled = false

  virtual_network_resource_ids_to_link_to = {
    "vnet1" = {
      vnet_resource_id = azurerm_virtual_network.this_1.id
    }
    "vnet2" = {
      vnet_resource_id = azurerm_virtual_network.this_2.id
    }
  }

  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
    }
  }

  enable_telemetry = var.enable_telemetry
}

# Region 2
resource "random_integer" "region_index_2" {
  max = length(module.regions.regions) - 2
  min = 0
}

module "naming_2" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "region_2" {
  location = module.regions.regions[random_integer.region_index_2.result].name
  name     = module.naming_2.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_2" {
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.region_2.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.region_2.name
}

module "test_region_2" {
  source = "../../"
  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"

  location            = azurerm_resource_group.region_2.location
  resource_group_name = azurerm_resource_group.region_2.name

  resource_group_creation_enabled = false

  virtual_network_resource_ids_to_link_to = {
    "vnet2" = {
      vnet_resource_id = azurerm_virtual_network.this_2.id
    }
  }

  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
    }
  }

  enable_telemetry = var.enable_telemetry
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.0, < 5.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.region_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_resource_group.region_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_virtual_network.this_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network.this_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_integer.region_index_1](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [random_integer.region_index_2](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming_1"></a> [naming\_1](#module\_naming\_1)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_naming_2"></a> [naming\_2](#module\_naming\_2)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: ~> 0.3

### <a name="module_test_region_1"></a> [test\_region\_1](#module\_test\_region\_1)

Source: ../../

Version:

### <a name="module_test_region_2"></a> [test\_region\_2](#module\_test\_region\_2)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->