locals {
  location_geo_code = module.regions.regions_by_name_or_display_name[var.location].geo_code
  location_name     = module.regions.regions_by_name_or_display_name[var.location].name
}

locals {
  private_link_private_dns_zones_filtered = {
    for k, v in local.private_link_private_dns_zones_regex_filtered : k => v if !(contains(var.private_link_excluded_zones, v.zone_name) || contains(var.private_link_excluded_zones, k))
  }
  private_link_private_dns_zones_final = {
    for k, v in local.private_link_private_dns_zones_replaced_regionCode_map : k => {
      zone_name                              = v.zone_name
      private_dns_zone_supports_private_link = local.private_link_private_dns_zones_filtered[k].private_dns_zone_supports_private_link
      resolution_policy                      = local.private_link_private_dns_zones_filtered[k].resolution_policy
      custom_iterator                        = local.private_link_private_dns_zones_filtered[k].custom_iterator
      virtual_network_links = merge({ for vnet_link_key, vnet_link_value in var.virtual_network_links_default : vnet_link_key => {
        virtual_network_resource_id                 = vnet_link_value.virtual_network_resource_id
        virtual_network_link_name_template_override = coalesce(vnet_link_value.virtual_network_link_name_template_override, var.virtual_network_link_name_template)
        resolution_policy                           = vnet_link_value.resolution_policy
        } },
        { for vnet_link_key, vnet_link_value in lookup(var.virtual_network_links_per_zone, k, {}) : vnet_link_key => {
          virtual_network_resource_id                 = vnet_link_value.virtual_network_resource_id
          virtual_network_link_name_template_override = coalesce(vnet_link_value.name, var.virtual_network_link_name_template)
          resolution_policy                           = vnet_link_value.resolution_policy
      } })
    }
  }
  private_link_private_dns_zones_merged = merge(var.private_link_private_dns_zones, var.private_link_private_dns_zones_additional)
  private_link_private_dns_zones_regex_filtered = var.private_link_private_dns_zones_regex_filter.enabled ? {
    for k, v in local.private_link_private_dns_zones_merged : k => v if length(regexall(var.private_link_private_dns_zones_regex_filter.regex_filter, v.zone_name)) > 0
  } : local.private_link_private_dns_zones_merged
  private_link_private_dns_zones_replaced_regionCode_map = {
    for k, v in local.private_link_private_dns_zones_replaced_regionName_map : k => {
      zone_name = replace(v.zone_name, "{regionCode}", local.location_geo_code)
    }
  }
  private_link_private_dns_zones_replaced_regionName_map = {
    for k, v in local.private_link_private_dns_zones_filtered : k => {
      zone_name = replace(v.zone_name, "{regionName}", local.location_name)
    }
  }
}

locals {
  combined_private_link_private_dns_zones_replaced_with_vnets_to_link = {
    for item in flatten([
      for zone_key, zone_value in local.private_link_private_dns_zones_final : [
        for custom_iterator_key, custom_iterator_value in try(zone_value.custom_iterator.replacement_values, { no_custom_iterator = null }) :
        {
          zone_key  = custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"
          zone_name = custom_iterator_value == null ? zone_value.zone_name : replace(zone_value.zone_name, "{${zone_value.custom_iterator.replacement_placeholder}}", custom_iterator_key)
          virtual_network_links = {
            for vnet_link_key, vnet_link_value in zone_value.virtual_network_links : vnet_link_key => {
              virtual_network_id = vnet_link_value.virtual_network_resource_id
              name = coalesce(local.virtual_network_link_overrides[zone_key][vnet_link_key].name, templatestring(
                vnet_link_value.virtual_network_link_name_template_override,
                {
                  zone_key  = custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"
                  vnet_key  = vnet_link_key
                  vnet_name = element(split("/", vnet_link_value.virtual_network_resource_id), length(split("/", vnet_link_value.virtual_network_resource_id)) - 1)
                  location  = var.location
                }
              ))
              registration_enabled                   = false
              private_dns_zone_supports_private_link = zone_value.private_dns_zone_supports_private_link
              resolution_policy                      = coalesce(local.virtual_network_link_overrides[zone_key][vnet_link_key].resolution_policy, zone_value.resolution_policy, vnet_link_value.resolution_policy, "Default")
              tags                                   = var.tags
            } if local.virtual_network_link_overrides[zone_key][vnet_link_key].enabled
          }
        }
      ]]
    ) : item.zone_key => item
  }
}

locals {
  virtual_network_link_overrides = {
    for zone_key, zone_value in local.private_link_private_dns_zones_final : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value.virtual_network_links : vnet_link_key =>
      try(var.virtual_network_link_overrides[zone_key][vnet_link_key], {
        name              = null
        resolution_policy = null
        enabled           = true
      })
    }
  }
}


locals {
  resource_group_id_string = var.parent_id
  resource_group_name      = split("/", local.resource_group_id_string)[4]
}
