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

module "test" {
  source = "../../"

  location         = module.regions.regions[random_integer.region_index.result].name
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
  private_link_excluded_zones = [
    "azure_ml_notebooks",
    "privatelink.{regionName}.azurecontainerapps.io",
    "privatelink.tip1.powerquery.microsoft.com"
  ]
  private_link_private_dns_zones = {
    azure_container_apps = {
      zone_name = "privatelink.{regionName}.azurecontainerapps.io"
    }
    azure_ml = {
      zone_name = "privatelink.api.azureml.ms"
    }
    azure_ml_notebooks = {
      zone_name = "privatelink.notebooks.azure.net"
    }

    azure_power_bi_dedicated = {
      zone_name = "privatelink.pbidedicated.windows.net"
    }
    azure_power_bi_power_query = {
      zone_name = "privatelink.tip1.powerquery.microsoft.com"
    }
  }
}
