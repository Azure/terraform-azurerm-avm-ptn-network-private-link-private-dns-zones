output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link" {
  description = "The final map of private link private DNS zones to link to virtual networks including the region name replacements as required."
  value       = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link
}

output "resource_group_resource_id" {
  description = "The resource ID of the resource group that the Private DNS Zones are deployed into."
  value       = var.resource_group_creation_enabled ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.this[0].id
}
