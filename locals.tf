locals {
  location_geo_code = module.regions.regions_by_name_or_display_name[var.location].geo_code
  location_name     = module.regions.regions_by_name_or_display_name[var.location].name
}

locals {
  resource_group_id_string = var.parent_id
  resource_group_name      = split("/", local.resource_group_id_string)[4]
}

locals {
  private_link_private_dns_zones_filtered = {
    for zone_key, zone_value in local.private_link_private_dns_zones_regex_filtered : zone_key => zone_value if !(contains(var.private_link_excluded_zones, zone_value.zone_name) || contains(var.private_link_excluded_zones, zone_key))
  }
  private_link_private_dns_zones_filtered_and_processed = {
    for zone_key, zone_value in local.private_link_private_dns_zones_filtered : zone_key => {
      zone_name                              = replace(replace(zone_value.zone_name, "{regionCode}", local.location_geo_code), "{regionName}", local.location_name)
      private_dns_zone_supports_private_link = zone_value.private_dns_zone_supports_private_link
      resolution_policy                      = zone_value.resolution_policy
      custom_iterator                        = zone_value.custom_iterator
      role_assignments                       = lookup(var.virtual_network_role_assignments, zone_key, {})
    }
  }
  private_link_private_dns_zones_merged = merge(var.private_link_private_dns_zones, var.private_link_private_dns_zones_additional)
  private_link_private_dns_zones_regex_filtered = var.private_link_private_dns_zones_regex_filter.enabled ? {
    for zone_key, zone_value in local.private_link_private_dns_zones_merged : zone_key => zone_value if length(regexall(var.private_link_private_dns_zones_regex_filter.regex_filter, zone_value.zone_name)) > 0
  } : local.private_link_private_dns_zones_merged
}

locals {
  virtual_network_link_merged = {
    for zone_key, zone_value in local.private_link_private_dns_zones_filtered_and_processed : zone_key => merge(
      { for vnet_link_key, vnet_link_value in var.virtual_network_link_default_virtual_networks : vnet_link_key => {
        virtual_network_resource_id                 = vnet_link_value.virtual_network_resource_id
        virtual_network_link_name_template_override = vnet_link_value.virtual_network_link_name_template_override
        resolution_policy                           = vnet_link_value.resolution_policy
      } },
      { for vnet_link_key, vnet_link_value in var.virtual_network_link_additional_virtual_networks : vnet_link_key => {
        virtual_network_resource_id                 = vnet_link_value.virtual_network_resource_id
        virtual_network_link_name_template_override = vnet_link_value.virtual_network_link_name_template_override
        resolution_policy                           = vnet_link_value.resolution_policy
      } },
      { for vnet_link_key, vnet_link_value in lookup(var.virtual_network_link_by_zone_and_virtual_network, zone_key, {}) : vnet_link_key => {
        virtual_network_resource_id                 = vnet_link_value.virtual_network_resource_id
        virtual_network_link_name_template_override = vnet_link_value.name
        resolution_policy                           = vnet_link_value.resolution_policy
      } }
    )
  }
}

locals {
  virtual_network_link_overrides_by_virtual_network = {
    for zone_key, zone_value in local.virtual_network_link_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key =>
      try(var.virtual_network_link_overrides_by_virtual_network[vnet_link_key], {
        virtual_network_link_name_template_override = null
        resolution_policy                           = null
        enabled                                     = true
      })
    }
  }
  virtual_network_link_overrides_by_zone = {
    for zone_key, zone_value in local.virtual_network_link_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key =>
      try(var.virtual_network_link_overrides_by_zone[zone_key], {
        virtual_network_link_name_template_override = null
        resolution_policy                           = null
        enabled                                     = true
      })
    }
  }
  virtual_network_link_overrides_by_zone_and_virtual_network = {
    for zone_key, zone_value in local.virtual_network_link_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key =>
      try(var.virtual_network_link_overrides_by_zone_and_virtual_network[zone_key][vnet_link_key], {
        name              = null
        resolution_policy = null
        enabled           = true
      })
    }
  }
  virtual_network_link_overrides_final = {
    for zone_key, zone_value in local.virtual_network_link_overrides_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key => {
        name              = vnet_link_value.name == "null" ? null : vnet_link_value.name
        resolution_policy = vnet_link_value.resolution_policy == "null" ? null : vnet_link_value.resolution_policy
        enabled           = vnet_link_value.enabled
      }
    }
  }
  virtual_network_link_overrides_merged = {
    for zone_key, zone_value in local.virtual_network_link_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key => {
        name = coalesce(
          local.virtual_network_link_overrides_by_zone_and_virtual_network[zone_key][vnet_link_key].name,
          local.virtual_network_link_overrides_by_zone[zone_key][vnet_link_key].virtual_network_link_name_template_override,
          local.virtual_network_link_overrides_by_virtual_network[zone_key][vnet_link_key].virtual_network_link_name_template_override,
          "null"
        )
        resolution_policy = coalesce(
          local.virtual_network_link_overrides_by_zone_and_virtual_network[zone_key][vnet_link_key].resolution_policy,
          local.virtual_network_link_overrides_by_zone[zone_key][vnet_link_key].resolution_policy,
          local.virtual_network_link_overrides_by_virtual_network[zone_key][vnet_link_key].resolution_policy,
          "null"
        )
        enabled = (
          local.virtual_network_link_overrides_by_zone_and_virtual_network[zone_key][vnet_link_key].enabled &&
          local.virtual_network_link_overrides_by_zone[zone_key][vnet_link_key].enabled &&
          local.virtual_network_link_overrides_by_virtual_network[zone_key][vnet_link_key].enabled
        )
      }
    }
  }
}

locals {
  virtual_network_link_merged_with_overrides = {
    for zone_key, zone_value in local.virtual_network_link_merged : zone_key => {
      for vnet_link_key, vnet_link_value in zone_value : vnet_link_key => {
        virtual_network_id = vnet_link_value.virtual_network_resource_id
        name = coalesce(
          local.virtual_network_link_overrides_final[zone_key][vnet_link_key].name,
          vnet_link_value.virtual_network_link_name_template_override,
          var.virtual_network_link_name_template
        )
        resolution_policy = coalesce(
          local.virtual_network_link_overrides_final[zone_key][vnet_link_key].resolution_policy,
          vnet_link_value.resolution_policy,
          local.private_link_private_dns_zones_filtered_and_processed[zone_key].resolution_policy,
          var.virtual_network_link_resolution_policy_default
        )
        private_dns_zone_supports_private_link = local.private_link_private_dns_zones_filtered_and_processed[zone_key].private_dns_zone_supports_private_link
      } if local.virtual_network_link_overrides_final[zone_key][vnet_link_key].enabled
    }
  }
}

locals {
  default_custom_iterator = {
    replacement_placeholder = ""
    replacement_values      = { empty = null }
  }
  private_link_private_dns_zones_final = {
    for item in flatten([
      for zone_key, zone_value in local.private_link_private_dns_zones_filtered_and_processed : [
        for custom_iterator_key, custom_iterator_value in coalesce(zone_value.custom_iterator, local.default_custom_iterator).replacement_values : {
          zone_key         = custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"
          zone_name        = custom_iterator_value == null ? zone_value.zone_name : replace(zone_value.zone_name, "{${zone_value.custom_iterator.replacement_placeholder}}", custom_iterator_key)
          role_assignments = custom_iterator_value == null ? zone_value.role_assignments : replace(zone_value.role_assignments, "{${zone_value.custom_iterator.replacement_placeholder}}", custom_iterator_key)
          virtual_network_links = { for vnet_link_key, vnet_link_value in local.virtual_network_link_merged_with_overrides[zone_key] : vnet_link_key => {
            virtual_network_id = vnet_link_value.virtual_network_id
            name = templatestring(vnet_link_value.name, {
              zone_key  = custom_iterator_value == null ? zone_key : "${zone_key}_${custom_iterator_key}"
              vnet_key  = vnet_link_key
              vnet_name = element(split("/", vnet_link_value.virtual_network_id), length(split("/", vnet_link_value.virtual_network_id)) - 1)
              location  = var.location
            })
            private_dns_zone_supports_private_link = vnet_link_value.private_dns_zone_supports_private_link
            registration_enabled                   = false
            resolution_policy                      = vnet_link_value.resolution_policy
            tags                                   = var.tags
            }
        } }
      ]]
    ) : item.zone_key => item
  }
}


