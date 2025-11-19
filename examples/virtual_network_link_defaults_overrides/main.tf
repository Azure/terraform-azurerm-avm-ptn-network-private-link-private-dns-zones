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
  version = "0.9.2"

  is_recommended = true
}

locals {
  # Filter regions to those with a geo code to avoid null replacements in the module locals.
  regions_with_geo_code = [
    for region in module.regions.regions : region if try(region.geo_code, null) != null
  ]
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
  location = local.regions_with_geo_code[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "vnet1" {
  location            = azurerm_resource_group.this.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "vnet2" {
  location            = azurerm_resource_group.this.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "vnet3" {
  location            = azurerm_resource_group.this.location
  name                = "vnet3"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.3.0/24"]
}


module "test" {
  source = "../../"

  location         = local.regions_with_geo_code[random_integer.region_index.result].name
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
  virtual_network_link_defaults = {
    "vnet1" = {
      virtual_network_resource_id                 = azurerm_virtual_network.vnet1.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
      resolution_policy                           = "Default"
    }
    "vnet2" = {
      virtual_network_resource_id                 = azurerm_virtual_network.vnet2.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
      resolution_policy                           = "NxDomainRedirect"
    }
    "vnet3" = {
      virtual_network_resource_id                 = azurerm_virtual_network.vnet3.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
      resolution_policy                           = "Default"
    }
  }
  virtual_network_link_defaults_overrides = {
    "vnet1" = {
      virtual_network_link_name_template_override = "overridden-$${vnet_key}-link"
      resolution_policy                           = "NxDomainRedirect"
    }
    "vnet2" = {
      virtual_network_link_name_template_override = "overridden-$${vnet_key}-link"
      resolution_policy                           = "Default"
    }
    "vnet3" = {
      enabled = false
    }
  }
}

