output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link" {
  description = "The final map of private link private DNS zones to link to virtual networks including the region name replacements as required."
  value       = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link
}

output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link_only_multi_region_zones" {
  description = "The final map of private link private DNS zones to link to virtual networks including the region name replacements as required, but ONLY for zones that have had region name or geo code replacements."
  value       = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link_only_multi_region_zones
}

output "resource_group_resource_id" {
  description = "The resource ID of the resource group that the Private DNS Zones are deployed into."
  value       = local.resource_group_resource_id
}
