output "private_dns_zone_resource_ids" {
  description = "The map of private DNS zones to resource ids."
  value       = { for key, mod in module.avm_res_network_privatednszone : key => mod.resource_id }
}

output "private_link_private_dns_zones_map" {
  description = "The final map of private link private DNS zones to link to virtual networks including the region name replacements as required."
  value       = local.private_link_private_dns_zones_final
}

output "resource_group_resource_id" {
  description = "The resource ID of the resource group that the Private DNS Zones are deployed into."
  value       = local.resource_group_id_string
}
