locals {
  combined_private_link_private_dns_zones_replaced_with_vnets_to_link = {
    for item in flatten([
      for zone_key, zone_value in local.private_link_private_dns_zones_replaced_regionCode_map : [
        {
          zone_key   = zone_key
          zone_value = zone_value
          vnets = {
            for vnet_key, vnet_value in var.virtual_network_resource_ids_to_link_to : vnet_key => {
              vnetid           = vnet_value.vnet_resource_id
              vnetlinkname     = templatestring(vnet_value.virtual_network_link_name_override == null ? var.virtual_network_link_name_template : vnet_value.virtual_network_link_name_template_override, { zone_key = zone_key, vnet_key = vnet_key })
              autoregistration = false
              tags             = var.tags
            }
          }
        }
      ]
      ]
    ) : item.zone_key => item
  }
  location_geo_code = module.regions.regions_by_name_or_display_name[var.location].geo_code
  location_name     = module.regions.regions_by_name_or_display_name[var.location].name
  private_link_private_dns_zones_replaced_regionCode_map = { for k, v in local.private_link_private_dns_zones_replaced_regionName_map : k => {
    zone_name = replace(v.zone_name, "{regionCode}", local.location_geo_code)
  } }
  private_link_private_dns_zones_replaced_regionName_map = { for k, v in var.private_link_private_dns_zones : k => {
    zone_name = replace(v.zone_name, "{regionName}", local.location_name)
  } }
  resource_group_resource_id         = var.resource_group_creation_enabled ? azurerm_resource_group.this[0].id : "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
