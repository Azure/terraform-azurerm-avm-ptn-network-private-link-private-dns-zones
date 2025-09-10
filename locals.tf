locals {
  location_geo_code = module.regions.regions_by_name_or_display_name[var.location].geo_code
  location_name     = module.regions.regions_by_name_or_display_name[var.location].name
}

locals {
  filtered_private_link_private_dns_zones = {
    for k, v in local.regex_filtered_private_link_private_dns_zones : k => v if !(contains(var.private_link_excluded_zones, v.zone_name) || contains(var.private_link_excluded_zones, k))
  }
  merged_private_link_private_dns_zones = merge(var.private_link_private_dns_zones, var.private_link_private_dns_zones_additional)
  private_link_private_dns_zones_replaced_regionCode_map = {
    for k, v in local.private_link_private_dns_zones_replaced_regionName_map : k => {
      zone_name = replace(v.zone_name, "{regionCode}", local.location_geo_code)
    }
  }
  private_link_private_dns_zones_replaced_regionName_map = {
    for k, v in local.filtered_private_link_private_dns_zones : k => {
      zone_name = replace(v.zone_name, "{regionName}", local.location_name)
    }
  }
  regex_filtered_private_link_private_dns_zones = var.private_link_private_dns_zones_regex_filter.enabled ? {
    for k, v in local.merged_private_link_private_dns_zones : k => v if length(regexall(var.private_link_private_dns_zones_regex_filter.regex_filter, v.zone_name)) > 0
  } : local.merged_private_link_private_dns_zones
  virtual_network_link_name_templates = { for key, value in var.virtual_network_resource_ids_to_link_to : key => value.virtual_network_link_name_template_override == null ? var.virtual_network_link_name_template : value.virtual_network_link_name_template_override }
}

locals {
  combined_private_link_private_dns_zones_replaced_with_vnets_to_link = {
    for item in flatten([
      for zone_key, zone_value in local.private_link_private_dns_zones_replaced_regionCode_map : [
        for custom_iterator_key, custom_iterator_value in try(local.filtered_private_link_private_dns_zones[zone_key].custom_iterator.replacement_values, { no_custom_iterator = null }) :
        {
          zone_key  = custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"
          zone_name = custom_iterator_value == null ? zone_value.zone_name : replace(zone_value.zone_name, "{${local.filtered_private_link_private_dns_zones[zone_key].custom_iterator.replacement_placeholder}}", custom_iterator_key)
          vnets = {
            for vnet_key, vnet_value in var.virtual_network_resource_ids_to_link_to : vnet_key => {
              virtual_network_id                     = vnet_value.vnet_resource_id
              name                                   = templatestring(local.virtual_network_link_name_templates[vnet_key], { zone_key = (custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"), vnet_key = vnet_key })
              registration_enabled                   = false
              private_dns_zone_supports_private_link = local.filtered_private_link_private_dns_zones[zone_key].private_dns_zone_supports_private_link
              resolution_policy                      = vnet_value.resolution_policy
              tags                                   = var.tags
            }
          }
        }
      ]]
    ) : item.zone_key => item
  }
}

locals {
  resource_group_id_string = "${data.azapi_client_config.current.subscription_resource_id}/resourceGroups/${var.resource_group_name}"
}
