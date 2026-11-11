terraform {
  required_version = "~> 1.5"

  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.13.0"

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

module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.5.0"

  location         = local.regions_with_geo_code[random_integer.region_index.result].name
  name             = module.naming.resource_group.name_unique
  enable_telemetry = var.enable_telemetry
}

module "test" {
  source = "../../"

  location         = module.resource_group.resource.location
  parent_id        = module.resource_group.resource_id
  enable_telemetry = var.enable_telemetry
}
