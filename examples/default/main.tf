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
  features {}
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


module "test" {
  source = "../../"
  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  location            = module.regions.regions[random_integer.region_index.result].name
  resource_group_name = module.naming.resource_group.name_unique

  enable_telemetry = var.enable_telemetry

}
