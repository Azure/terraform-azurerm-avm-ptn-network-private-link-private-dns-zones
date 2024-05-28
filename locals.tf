locals {

  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"

  location_lowered    = lower(var.location)
  location_short_name = strcontains(local.location_lowered, " ") ? local.azure_region_short_names_display_name_as_key[local.location_lowered] : local.location_lowered

  azure_region_short_names_display_name_as_key = {
    "australia southeast" : "australiasoutheast",
    "west central us" : "westcentralus",
    "chile central" : "chilecentral",
    "east us 2 euap" : "eastus2euap",
    "japan west" : "japanwest",
    "west us 2" : "westus2",
    "uae central" : "uaecentral",
    "france central" : "francecentral",
    "east us 2" : "eastus2",
    "malaysia west" : "malaysiawest",
    "korea south" : "koreasouth",
    "switzerland west" : "switzerlandwest",
    "west us" : "westus",
    "australia central 2" : "australiacentral2",
    "north europe" : "northeurope",
    "switzerland north" : "switzerlandnorth",
    "uae north" : "uaenorth",
    "australia east" : "australiaeast",
    "new zealand north" : "newzealandnorth",
    "japan east" : "japaneast",
    "norway east" : "norwayeast",
    "south india" : "southindia",
    "korea central" : "koreacentral",
    "malaysia south" : "malaysiasouth",
    "uk south" : "uksouth",
    "qatar central" : "qatarcentral",
    "canada east" : "canadaeast",
    "north central us" : "northcentralus",
    "east asia" : "eastasia",
    "uk west" : "ukwest",
    "brazil southeast" : "brazilsoutheast",
    "canada central" : "canadacentral",
    "germany north" : "germanynorth",
    "west india" : "westindia",
    "italy north" : "italynorth",
    "israel central" : "israelcentral",
    "brazil south" : "brazilsouth",
    "central us euap" : "centraluseuap",
    "germany west central" : "germanywestcentral",
    "south africa north" : "southafricanorth",
    "sweden south" : "swedensouth",
    "poland central" : "polandcentral",
    "spain central" : "spaincentral",
    "south central us" : "southcentralus",
    "east us" : "eastus",
    "southeast asia" : "southeastasia",
    "france south" : "francesouth",
    "australia central" : "australiacentral",
    "central us" : "centralus",
    "central india" : "centralindia",
    "norway west" : "norwaywest",
    "mexico central" : "mexicocentral",
    "west europe" : "westeurope",
    "south africa west" : "southafricawest",
    "west us 3" : "westus3",
    "taiwan north" : "taiwannorth",
    "sweden central" : "swedencentral"
  }
  azure_region_geo_codes_short_name_as_key = {
    "uaenorth" : "uan",
    "northcentralus" : "ncus",
    "malaysiawest" : "myw",
    "eastus" : "eus",
    "uksouth" : "uks",
    "westcentralus" : "wcus",
    "israelcentral" : "ilc",
    "southeastasia" : "sea",
    "malaysiasouth" : "mys",
    "koreacentral" : "krc",
    "northeurope" : "ne",
    "australiaeast" : "ae",
    "southafricanorth" : "san",
    "norwaywest" : "nww",
    "norwayeast" : "nwe",
    "westus3" : "wus3",
    "eastus2euap" : "ecy",
    "centralus" : "cus",
    "mexicocentral" : "mxc",
    "canadacentral" : "cnc",
    "japaneast" : "jpe",
    "swedencentral" : "sdc",
    "taiwannorth" : "twn",
    "germanynorth" : "gn",
    "centralindia" : "inc",
    "westindia" : "inw",
    "newzealandnorth" : "nzn",
    "australiacentral" : "acl",
    "ukwest" : "ukw",
    "germanywestcentral" : "gwc",
    "brazilsouth" : "brs",
    "francecentral" : "frc",
    "brazilsoutheast" : "bse",
    "westus2" : "wus2",
    "eastus2" : "eus2",
    "centraluseuap" : "ccy",
    "australiacentral2" : "acl2",
    "francesouth" : "frs",
    "southafricawest" : "saw",
    "koreasouth" : "krs",
    "southindia" : "ins",
    "canadaeast" : "cne",
    "qatarcentral" : "qac",
    "spaincentral" : "spc",
    "westeurope" : "we",
    "japanwest" : "jpw",
    "southcentralus" : "scus",
    "polandcentral" : "plc",
    "switzerlandwest" : "szw",
    "australiasoutheast" : "ase",
    "switzerlandnorth" : "szn",
    "italynorth" : "itn",
    "uaecentral" : "uac",
    "eastasia" : "ea",
    "chilecentral" : "clc",
    "westus" : "wus",
    "swedensouth" : "sds"
  }

  private_link_private_dns_zones_replaced_regionName_map = { for k, v in var.private_link_private_dns_zones : k => {
    zone_name = replace(v.zone_name, "{regionName}", local.location_short_name)
  } }

  private_link_private_dns_zones_replaced_regionCode_map = { for k, v in local.private_link_private_dns_zones_replaced_regionName_map : k => {
    zone_name = replace(v.zone_name, "{regionCode}", local.azure_region_geo_codes_short_name_as_key[local.location_short_name])
  } }

# Use a DIY approach

  combined_private_link_private_dns_zones_replaced_with_vnets_to_link = {
    for item in flatten([
      for zone_key, zone_value in local.private_link_private_dns_zones_replaced_regionCode_map : [
        for vnet_key, vnet_value in var.virtual_network_resource_ids_to_link_to : {
          zone_key   = zone_key
          zone_value = zone_value
          vnet_key   = vnet_key
          vnet_value = vnet_value
        }
      ]
      ]
    ) : "${item.zone_key}/${item.vnet_key}" => item
  }


#########

# Use setproduct()

  set_of_private_link_private_dns_zones_replaced_regionCode = [
    for k, v in local.private_link_private_dns_zones_replaced_regionCode_map : {
      key       = k
      zone_name = v.zone_name
    }
  ]

  set_of_virtual_network_resource_ids_to_link_to = [
    for k, v in var.virtual_network_resource_ids_to_link_to : {
      key              = k
      vnet_resource_id = v.vnet_resource_id
    }
  ]

  product_of_private_link_private_dns_zones_replaced_combined_with_vnets_to_link = [
    for pair in setproduct(local.set_of_private_link_private_dns_zones_replaced_regionCode, local.set_of_virtual_network_resource_ids_to_link_to) : {
      zone_key   = pair[0].key
      zone_value = pair[0].zone_name
      vnet_key   = pair[1].key
      vnet_value = pair[1].vnet_resource_id
    }
  ]

}
