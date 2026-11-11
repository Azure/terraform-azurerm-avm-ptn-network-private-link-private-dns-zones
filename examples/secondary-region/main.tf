terraform {
  required_version = "~> 1.5"

  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
  }
}

module "naming" {
  source  = "Azure/avm-utl-naming/azure"
  version = "0.2.0"
}

module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.5.0"

  location         = "uksouth"
  name             = module.naming.resource_group.name_unique
  enable_telemetry = var.enable_telemetry
}

module "test" {
  source = "../../"

  location         = "uksouth"
  parent_id        = module.resource_group.resource_id
  enable_telemetry = var.enable_telemetry
  private_link_private_dns_zones_regex_filter = {
    enabled = true
  }
}
