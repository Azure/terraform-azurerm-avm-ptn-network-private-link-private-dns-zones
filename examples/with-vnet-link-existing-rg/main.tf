terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
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
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_1" {
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.this.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_virtual_network" "this_2" {
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.this.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.this.name
}

module "test" {
  source = "../../"
  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  resource_group_creation_enabled = false

  virtual_network_resource_ids_to_link_to = {
    "vnet1" = {
      vnet_resource_id = azurerm_virtual_network.this_1.id
    }
    "vnet2" = {
      vnet_resource_id = azurerm_virtual_network.this_2.id
    }
  }

  enable_telemetry = var.enable_telemetry
}
