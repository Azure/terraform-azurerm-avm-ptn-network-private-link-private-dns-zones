terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
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

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.7.0"
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_1" {
  location            = azurerm_resource_group.this.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "this_2" {
  location            = azurerm_resource_group.this.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.2.0/24"]
}

module "test" {
  # source = "../../"
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.17.0"

  location = azurerm_resource_group.this.location

  resource_group_name             = azurerm_resource_group.this.name
  resource_group_creation_enabled = false
  enable_telemetry                = var.enable_telemetry
  private_link_private_dns_zones_additional = {
    example_zone_1 = {
      zone_name = "{regionCode}.example.com"

    }
    example_zone_2 = {
      zone_name = "{customIterator}.example.com"
      custom_iterator = {
        replacement_placeholder = "customIterator"
        replacement_values = {
          custom1 = "custom1"
          custom2 = "custom2"
        }
      }
    }
  }
  virtual_network_resource_ids_to_link_to = {
    "vnet1" = {
      vnet_resource_id                            = azurerm_virtual_network.this_1.id
      virtual_network_link_name_template_override = "vnet1-link"
    }
    "vnet2" = {
      vnet_resource_id                            = azurerm_virtual_network.this_2.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
    }
  }
}

# Moved block examples based on above declaration. Use as starting point for your own migrations/upgrades to the latest version of the module using the azapi provider.
## Private DNS Zones - only needed as these are custom DNS zones (e.g. not the default value of the variable `private_link_private_dns_zones`, as these are handled by the module)
# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone.this
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].azapi_resource.private_dns_zone
# }

# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone.this
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].azapi_resource.private_dns_zone
# }

# ## vNet Links
# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
# }

# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
# }

# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
# }

# moved {
#   from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
#   to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
# }
