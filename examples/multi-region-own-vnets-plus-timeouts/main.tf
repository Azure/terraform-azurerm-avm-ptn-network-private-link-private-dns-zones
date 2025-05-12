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

data "azurerm_client_config" "current" {}

# Region 1
module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

resource "random_integer" "region_index_1" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming_1" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "region_1" {
  location = module.regions.regions[random_integer.region_index_1.result].name
  name     = module.naming_1.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_1" {
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.region_1.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.region_1.name
}

module "test_region_1" {
  source = "../../"

  location                        = azurerm_resource_group.region_1.location
  resource_group_name             = azurerm_resource_group.region_1.name
  enable_telemetry                = var.enable_telemetry
  resource_group_creation_enabled = false
  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
    }
  }
  timeouts = {
    dns_zones = {
      create = "50m"
      delete = "50m"
      read   = "10m"
      update = "50m"
    }
    vnet_links = {
      create = "50m"
      delete = "50m"
      read   = "10m"
      update = "50m"
    }
  }
  virtual_network_resource_ids_to_link_to = {
    "vnet1" = {
      vnet_resource_id = azurerm_virtual_network.this_1.id
    }
  }
}

# Region 2
resource "random_integer" "region_index_2" {
  max = length(module.regions.regions) - 2
  min = 0
}

module "naming_2" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "region_2" {
  location = module.regions.regions[random_integer.region_index_2.result].name
  name     = module.naming_2.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_2" {
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.region_2.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.region_2.name
}

module "test_region_2" {
  source = "../../"

  location                        = azurerm_resource_group.region_2.location
  resource_group_name             = azurerm_resource_group.region_2.name
  enable_telemetry                = var.enable_telemetry
  resource_group_creation_enabled = false
  resource_group_role_assignments = {
    "rbac-asi-1" = {
      role_definition_id_or_name       = "Reader"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = true
    }
  }
  timeouts = {
    dns_zones = {
      create = "50m"
      delete = "50m"
      read   = "10m"
      update = "50m"
    }
    vnet_links = {
      create = "50m"
      delete = "50m"
      read   = "10m"
      update = "50m"
    }
  }
  virtual_network_resource_ids_to_link_to = {
    "vnet2" = {
      vnet_resource_id = azurerm_virtual_network.this_2.id
    }
  }
}
