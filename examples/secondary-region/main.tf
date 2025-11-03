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
  version = "0.4.2"
}

resource "azurerm_resource_group" "this" {
  location = "uksouth"
  name     = module.naming.resource_group.name_unique
}

module "test" {
  source = "../../"

  parent_id        = azurerm_resource_group.this.id
  location         = "uksouth"
  enable_telemetry = var.enable_telemetry
  private_link_private_dns_zones_regex_filter = {
    enabled = true
  }
}
