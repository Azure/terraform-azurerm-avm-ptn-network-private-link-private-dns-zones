resource "azapi_resource" "rg" {
  count = var.resource_group_creation_enabled ? 1 : 0

  parent_id = data.azapi_client_config.current.subscription_resource_id
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"

  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

data "azapi_client_config" "current" {}

module "avm_interfaces" {
  source  = "Azure/avm-utl-interfaces/azure"
  version = "0.5.0"

  lock                                      = var.lock
  enable_telemetry                          = var.enable_telemetry
  role_assignment_definition_scope          = local.resource_group_resource_id
  role_assignments                          = var.resource_group_role_assignments

}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.7.0"

  enable_telemetry   = var.enable_telemetry
  recommended_filter = false
}

module "avm_res_network_privatednszone" {
  source   = "Azure/avm-res-network-privatednszone/azurerm"
  version  = "0.4.1"
  for_each = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link

  parent_id = local.resource_group_resource_id

  domain_name           = each.value.zone_name
  enable_telemetry      = var.enable_telemetry
  tags                  = var.tags
  timeouts              = var.timeouts
  virtual_network_links = each.value.vnets
}

resource "azapi_resource" "lock" {
  count = var.lock != null ? 1 : 0

  name           = coalesce(module.avm_interfaces.lock_azapi.name, "lock-${azapi_resource.rg[0].name}")
  parent_id      = local.resource_group_resource_id
  type           = module.avm_interfaces.lock_azapi.type
  body           = module.avm_interfaces.lock_azapi.body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}

resource "azapi_resource" "role_assignments" {
  for_each = module.avm_interfaces.role_assignments_azapi

  name           = each.value.name
  parent_id      = local.resource_group_resource_id
  type           = each.value.type
  body           = each.value.body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}
