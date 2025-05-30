terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
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

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

resource "azurerm_resource_group" "this" {
  location = "uksouth"
  name     = module.naming.resource_group.name_unique
}

module "test" {
  source = "../../"

  # source             = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = var.enable_telemetry
  private_link_private_dns_zones_regex_filter = {
    enabled = true
  }
  resource_group_creation_enabled = false
}
