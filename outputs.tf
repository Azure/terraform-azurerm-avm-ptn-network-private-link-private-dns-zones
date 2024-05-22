# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
# output "resource" {
#   description = "This is the full output for the resource."
#   value       = azurerm_resource_group.TODO # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
# }

# output "out_private_link_private_dns_zones_replaced_regionName" {
#   value = local.private_link_private_dns_zones_replaced_regionName
# }

output "out_private_link_private_dns_zones" {
  value = local.private_link_private_dns_zones_replaced_regionCode
}