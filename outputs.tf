# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs


output "private_link_private_dns_zones_with_replacements" {
  value = local.private_link_private_dns_zones_replaced_regionCode_map
}

output "combined_private_link_private_dns_zones_replaced_with_vnets_to_link" {
  value = local.combined_private_link_private_dns_zones_replaced_with_vnets_to_link
}
