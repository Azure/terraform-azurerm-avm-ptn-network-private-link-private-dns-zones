resource "azurerm_resource_group" "this" {
  count = var.resoruce_group_creation_enabled ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

# module "avm-res-network-privatednszone" {
#   for_each = local.private_link_private_dns_zones_replaced_regionCode

#   source  = "Azure/avm-res-network-privatednszone/azurerm"
#   version = "0.1.1"

#   resource_group_name = var.resoruce_group_creation_enabled ? azurerm_resource_group.this[0].name : var.resource_group_name
#   domain_name         = each.value
#   # virtual_network_links = 
# }

# # required AVM resources interfaces
# # resource "azurerm_management_lock" "this" {
# #   count = var.lock != null ? 1 : 0

# #   lock_level = var.lock.kind
# #   name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
# #   scope      = azurerm_MY_RESOURCE.this.id
# #   notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
# # }

# # resource "azurerm_role_assignment" "this" {
# #   for_each = var.role_assignments

# #   principal_id                           = each.value.principal_id
# #   scope                                  = azurerm_resource_group.TODO.id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
# #   condition                              = each.value.condition
# #   condition_version                      = each.value.condition_version
# #   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
# #   role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
# #   role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
# #   skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
# # }
