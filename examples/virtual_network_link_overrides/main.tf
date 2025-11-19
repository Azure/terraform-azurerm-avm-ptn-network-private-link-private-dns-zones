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
  max = length(local.regions_with_geo_code) - 1
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

resource "azurerm_virtual_network" "vnet4" {
  location            = azurerm_resource_group.this.location
  name                = "vnet4"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.4.0/24"]
}

module "test" {
  source = "../../"

  location         = azurerm_resource_group.this.location
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
  virtual_network_link_defaults = {
    "vnet1" = {
      virtual_network_resource_id                 = azurerm_virtual_network.vnet1.id
      virtual_network_link_name_template_override = "vnet1-link"
      resolution_policy                           = "Default"
    }
    "vnet2" = {
      virtual_network_resource_id                 = azurerm_virtual_network.vnet2.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
      resolution_policy                           = "NxDomainRedirect"
    }
  }
  virtual_network_link_overrides = {
    azure_container_apps = {
      vnet1 = {
        resolution_policy = "NxDomainRedirect"
      }
      vnet2 = {
        name              = "custom-vnet2-link-name-aca"
        resolution_policy = "Default"
      }
    }
    azure_ml = {
      vnet1 = {
        name              = "custom-vnet1-link-name-aml"
        resolution_policy = "Default"
        enabled           = true
      }
      vnet2 = {
        enabled = false
      }
      vnet3 = {
        name              = "custom-vnet3-link-name-aml"
        resolution_policy = "NxDomainRedirect"
      }
    }
  }
  virtual_network_link_per_zone = {
    azure_container_apps = {
      "vnet1" = {
        virtual_network_resource_id = azurerm_virtual_network.vnet4.id
        name                        = "vnet4-link-aca-override-vnet1"
        resolution_policy           = "Default"
      }
      "vnet3" = {
        virtual_network_resource_id = azurerm_virtual_network.vnet3.id
        name                        = "vnet3-link-aca"
      }
    }
    azure_ml = {
      "vnet3" = {
        virtual_network_resource_id = azurerm_virtual_network.vnet3.id
        name                        = "this-will-be-overridden-by-override-block"
        resolution_policy           = "Default"
      }
      "vnet4" = {
        virtual_network_resource_id = azurerm_virtual_network.vnet4.id
        resolution_policy           = "NxDomainRedirect"
      }
    }
  }
}

