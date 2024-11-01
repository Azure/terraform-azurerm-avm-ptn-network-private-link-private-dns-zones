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

data "azurerm_client_config" "current" {}

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

module "test" {
  source = "../../"
  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  location            = module.regions.regions[random_integer.region_index.result].name
  resource_group_name = module.naming.resource_group.name_unique

  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
    }
  }

  enable_telemetry = var.enable_telemetry

}
