terraform {
  required_version = "~> 1.5"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    modtm = {
      source  = "registry.terraform.io/azure/modtm"
      version = "~> 0.3"
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
  version = "0.13.0"
  providers = {
    azapi = azapi
  }

  location         = var.location
  enable_telemetry = var.enable_telemetry
  is_recommended   = true
  use_cached_data  = false
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
  source  = "Azure/avm-utl-naming/azure"
  version = "0.2.0"
}

resource "azurerm_resource_group" "this" {
  location = local.regions_with_geo_code[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

module "test" {
  source = "../../"
  providers = {
    azapi = azapi
    modtm = modtm
  }

  location         = azurerm_resource_group.this.location
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
}
