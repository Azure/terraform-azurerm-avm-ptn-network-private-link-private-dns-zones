output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link" {
  description = "The final map of private link private DNS zones to link to virtual networks including the region name replacements as required."
  value       = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link
}

output "private_dns_zone_resource_ids" {
  description = "The map of private DNS zones to resource ids."
  value = { for key, mod in module.avm_res_network_privatednszone : key => {
    zone_id        = mod.resource_id
    zone_group_ids = var.private_link_private_dns_zones[key].groups_ids
    }
  }
}

output "resource_group_resource_id" {
  description = "The resource ID of the resource group that the Private DNS Zones are deployed into."
  value       = local.resource_group_resource_id
}
