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

module "vnet1" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.23.0"

  location         = module.resource_group.resource.location
  parent_id        = module.resource_group.resource_id
  address_space    = ["10.0.1.0/24"]
  enable_telemetry = var.enable_telemetry
  name             = "vnet1"
}

module "vnet2" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.23.0"

  location         = module.resource_group.resource.location
  parent_id        = module.resource_group.resource_id
  address_space    = ["10.0.2.0/24"]
  enable_telemetry = var.enable_telemetry
  name             = "vnet2"
}

module "test" {
  source = "../../"

  location         = module.resource_group.resource.location
  parent_id        = module.resource_group.resource_id
  enable_telemetry = var.enable_telemetry
  private_link_private_dns_zones = {
    azure_container_apps = {
      zone_name                              = "privatelink.{regionName}.azurecontainerapps.io"
      private_dns_zone_supports_private_link = true
      resolution_policy                      = "NxDomainRedirect"
    }
    azure_ml = {
      zone_name                              = "privatelink.api.azureml.ms"
      private_dns_zone_supports_private_link = true
    }
    azure_ml_notebooks = {
      zone_name                              = "privatelink.notebooks.azure.net"
      private_dns_zone_supports_private_link = true
      resolution_policy                      = "NxDomainRedirect"
    }
    azure_power_bi_dedicated = {
      zone_name                              = "privatelink.pbidedicated.windows.net"
      private_dns_zone_supports_private_link = true
    }
    azure_power_bi_power_query = {
      zone_name                              = "privatelink.prod.powerquery.microsoft.com"
      private_dns_zone_supports_private_link = true
      resolution_policy                      = "NxDomainRedirect"
    }
  }
  virtual_network_link_default_virtual_networks = {
    "vnet1" = {
      virtual_network_resource_id                 = module.vnet1.resource_id
      virtual_network_link_name_template_override = "vnet1-link"
    }
    "vnet2" = {
      virtual_network_resource_id                 = module.vnet2.resource_id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
    }
  }
}
