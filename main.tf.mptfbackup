resource "azurerm_resource_group" "this" {
  count = var.resource_group_creation_enabled ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

data "azurerm_client_config" "current" {}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.5.0"

  enable_telemetry   = var.enable_telemetry
  recommended_filter = false
}

module "avm_res_network_privatednszone" {
  source   = "Azure/avm-res-network-privatednszone/azurerm"
  version  = "0.3.0"
  for_each = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link

  domain_name           = each.value.zone_value.zone_name
  resource_group_name   = var.resource_group_creation_enabled ? azurerm_resource_group.this[0].name : var.resource_group_name
  enable_telemetry      = var.enable_telemetry
  tags                  = var.tags
  timeouts              = var.timeouts
  virtual_network_links = each.value.vnets
}

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = local.resource_group_resource_id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.resource_group_role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = local.resource_group_resource_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
