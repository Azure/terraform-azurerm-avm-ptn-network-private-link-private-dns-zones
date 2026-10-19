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
  source  = "Azure/avm-utl-naming/azure"
  version = "0.2.0"
}

resource "azurerm_resource_group" "this" {
  location = "uksouth"
  name     = module.naming.resource_group.name_unique
}

module "test" {
  source = "../../"
  providers = {
    azapi = azapi
    modtm = modtm
  }

  location         = "uksouth"
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
  private_link_private_dns_zones_regex_filter = {
    enabled = true
  }
}
