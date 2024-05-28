# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs

output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link" {
  value = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link
}

# output "private_link_private_dns_zones_resource_ids" {
#   value = {for zone in module.avm_res_network_privatednszone :
#     zone.key => zone.value.private_dns_zone_id
#   }
# }
