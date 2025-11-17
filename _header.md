# terraform-azurerm-avm-ptn-network-private-link-private-dns-zones

This module deploys all known Azure Private DNS Zones for Azure Services that support Private Link as documented and detailed here in [Azure Private Endpoint private DNS zone values](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).

The module also has logic built in to it to handle the replacements of the following strings in the Private DNS Zone Names to the appropriate Azure Region name, short name or geo-code as required:

- `...{regionName}...`
- `...{regionCode}...`


> [!NOTE]
> This module only supports Azure Public/Commercial today and **NOT** Azure US Government Cloud (a.k.a. Fairfax) or Azure China Cloud (a.k.a. Mooncake). If you would like to see support added for these clouds please raise an issue/feature request on this repo/module.

## Migrating from versions `v0.17.0` and prior to `v0.18.0` and later

Versions `v0.17.0` and prior of this module used `azurerm` as its primary provider as the version of the `Azure/avm-res-network-privatednszone/azurerm` module it leveraged was built using `azurerm` as its primary provider also.

As of version `v0.18.0` and later of this module, the module has been re-architected to use `azapi` as its primary provider as the version of the `Azure/avm-res-network-privatednszone/azurerm` module (`v0.4.1`) it now leverages is built using `azapi` as its primary provider also.

> Version `v0.18.0` of this module includes support for the Resolution Policy on the Private DNS Zone Virtual Network Links to allow for NXDomain Redirects to be configured, as documented in [Fallback to internet for Azure Private DNS zones](https://learn.microsoft.com/azure/dns/private-dns-fallback); see the new input properties in the `private_link_private_dns_zones` (`private_dns_zone_supports_private_link`), `private_link_private_dns_zones_additional` (`private_dns_zone_supports_private_link`), and `virtual_network_links` (`resolution_policy`) input variables.

This means that if you are using version `v0.17.0` or prior of this module and wish to upgrade to version `v0.18.0` or later, you will need to make some changes to your code to complete a successful upgrade.

Whilst we have used `moved` blocks in the module itself, see [`moved.tf`](moved.tf), to help with the migration, we have only been able to do this for the resources that are default created by the module. These are:

- The Private Link Private DNS Zones declared in the default value of the `private_link_private_dns_zones` input variable.
- The Resource Group created by the module if you are not using an existing Resource Group, as controlled by the `resource_group_creation_enabled` input variable.

For other resources that can be created by this module, you will need to declare your own `moved` blocks in your code (root module) to help with the migration. These resources are:

- Private DNS Zones declared in the `private_link_private_dns_zones_additional` input variable.
- Private DNS Zones Virtual Network Links declared in the `virtual_network_links` input variable.
- Role Assignments created on the Resource Group declared in the `resource_group_role_assignments` input variable.
- Locks created on the Resource Group declared in the `lock` input variable.

> You may decide it is not worth migrating some of these resources and instead allow Terraform to delete and recreate them. Such as the Role Assignments and Locks on the Resource Group. However, you should consider the impact of this before doing so based on your understanding of your environment and code.

To help with this we have provided some example `moved` blocks that you can copy, paste, and amend/edit into your code (root module) to help with the migration. You can find these example `moved` blocks in the following example's `main.tf` files:

- [custom-zones-vnet-link-existing-rg-including-moved-blocks](examples/custom-zones-vnet-link-existing-rg-including-moved-blocks/main.tf) - lines `106` onwards
- [with-vnet-link-existing-rg-including-moved-blocks](examples/with-vnet-link-existing-rg-including-moved-blocks/main.tf) - lines `104` onwards

You will also note that there are a number of new resources to be created relating to telemetry and the `modtm` provider, these do not need any `moved` blocks and are expected to be created as new resources to improve our AVM modules telemetry and insights.

If you have any questions or need any help with the migration please raise an issue on this repo/module and we will do our best to help. However, we believe we have provided comprehensive guidance and examples to help with the migration to prevent the deletion of critical resources.

---

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.
