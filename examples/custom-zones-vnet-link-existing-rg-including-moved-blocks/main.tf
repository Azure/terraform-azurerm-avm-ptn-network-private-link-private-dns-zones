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
  source = "../../"

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = var.enable_telemetry
  private_link_private_dns_zones = {
    "custom_zone_1" = {
      zone_name                              = "custom-example-1.int"
      private_dns_zone_supports_private_link = false
      virtual_network_links = {
        "vnet1" = {
          vnet_resource_id  = azurerm_virtual_network.this_1.id
          resolution_policy = "Default"
        }
        "vnet2" = {
          vnet_resource_id  = azurerm_virtual_network.this_2.id
          resolution_policy = "NxDomainRedirect" # This won't be passed through as the zones above are marked as not supporting private link
        }
      }
    }
    "custom_zone_2" = {
      zone_name                              = "custom-example-2.local"
      private_dns_zone_supports_private_link = false
      virtual_network_links = {
        "vnet1" = {
          vnet_resource_id  = azurerm_virtual_network.this_1.id
          resolution_policy = "Default"
        }
        "vnet2" = {
          vnet_resource_id  = azurerm_virtual_network.this_2.id
          resolution_policy = "NxDomainRedirect" # This won't be passed through as the zones above are marked as not supporting private link
        }
      }
    }
    "custom_zone_3" = {
      zone_name                              = "custom-example-3-{regionName}.local"
      private_dns_zone_supports_private_link = false
      virtual_network_links = {
        "vnet1" = {
          vnet_resource_id  = azurerm_virtual_network.this_1.id
          resolution_policy = "Default"
        }
        "vnet2" = {
          vnet_resource_id  = azurerm_virtual_network.this_2.id
          resolution_policy = "NxDomainRedirect" # This won't be passed through as the zones above are marked as not supporting private link
        }
      }
    }
    "custom_zone_4" = {
      zone_name                              = "custom-example-4-{regionCode}.local"
      private_dns_zone_supports_private_link = false
      virtual_network_links = {
        "vnet1" = {
          vnet_resource_id  = azurerm_virtual_network.this_1.id
          resolution_policy = "Default"
        }
        "vnet2" = {
          vnet_resource_id  = azurerm_virtual_network.this_2.id
          resolution_policy = "NxDomainRedirect" # This won't be passed through as the zones above are marked as not supporting private link
        }
      }
    }
  }
  resource_group_creation_enabled = false
  tags = {
    "env"             = "example"
    "example-tag-key" = "example tag value"
  }
}

# Moved block examples based on above declaration. Use as starting point for your own migrations/upgrades to the latest version of the module using the azapi provider.
## Private DNS Zones - only needed as these are custom DNS zones (e.g. not the default value of the variable `private_link_private_dns_zones`, as these are handled by the module)
moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_1"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_1"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_2"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_2"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_3"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_3"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_4"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_4"].azapi_resource.private_dns_zone
}

## vNet Links
moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_1"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_1"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_3"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_3"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_3"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_3"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_4"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_4"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["custom_zone_4"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["custom_zone_4"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}
