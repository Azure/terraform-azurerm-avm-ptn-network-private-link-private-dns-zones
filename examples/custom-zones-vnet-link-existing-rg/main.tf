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
  source = "../../"

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = var.enable_telemetry
  private_link_private_dns_zones = {
    "custom_zone_1" = {
      zone_name = "custom-example-1.int"
    }
    "custom_zone_2" = {
      zone_name = "custom-example-2.local"
    }
    "custom_zone_3" = {
      zone_name = "custom-example-3-{regionName}.local"
    }
    "custom_zone_4" = {
      zone_name = "custom-example-4-{regionCode}.local"
    }
  }
  resource_group_creation_enabled = false
  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
    }
  }
  tags = {
    "env"             = "example"
    "example-tag-key" = "example tag value"
  }
  virtual_network_resource_ids_to_link_to = {
    "vnet1" = {
      vnet_resource_id = azurerm_virtual_network.this_1.id
    }
    "vnet2" = {
      vnet_resource_id = azurerm_virtual_network.this_2.id
    }
  }
}
