module "avm_interfaces" {
  source  = "Azure/avm-utl-interfaces/azure"
  version = "0.5.0"

  enable_telemetry                 = var.enable_telemetry
  lock                             = var.lock
  role_assignment_definition_scope = local.resource_group_id_string
  role_assignments                 = var.resource_group_role_assignments
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.9.2"

  enable_telemetry = var.enable_telemetry
}

module "avm_res_network_privatednszone" {
  source   = "Azure/avm-res-network-privatednszone/azurerm"
  version  = "0.4.2"
  for_each = local.private_link_private_dns_zones_final

  domain_name           = each.value.zone_name
  parent_id             = local.resource_group_id_string
  enable_telemetry      = var.enable_telemetry
  tags                  = var.tags
  timeouts              = var.timeouts
  virtual_network_links = each.value.virtual_network_links
}

resource "azapi_resource" "lock" {
  count = var.lock != null ? 1 : 0

  name           = coalesce(module.avm_interfaces.lock_azapi.name, "lock-${local.resource_group_name}")
  parent_id      = local.resource_group_id_string
  type           = module.avm_interfaces.lock_azapi.type
  body           = module.avm_interfaces.lock_azapi.body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}

resource "azapi_resource" "role_assignments" {
  for_each = module.avm_interfaces.role_assignments_azapi

  name           = each.value.name
  parent_id      = local.resource_group_id_string
  type           = each.value.type
  body           = each.value.body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
}



