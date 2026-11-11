# terraform-azurerm-avm-ptn-network-private-link-private-dns-zones

This module deploys all known private link private DNS zones for Azure Services that support Private Link as documented and detailed here in [Azure Private Endpoint private DNS zone values](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).

The module also has logic built in to it to handle the replacements of the following strings in the private link private DNS zone names to the appropriate Azure Region name, short name or geo-code as required:

- `...{regionName}...`
- `...{regionCode}...`


> [!NOTE]
> This module only supports Azure Public/Commercial today and **NOT** Azure US Government Cloud (a.k.a. Fairfax) or Azure China Cloud (a.k.a. Mooncake). If you would like to see support added for these clouds please raise an issue/feature request on this repo/module.

## Upgrade considerations

The private DNS zone dependency is upgraded from `0.4.3` to `0.6.0`. Zone and
virtual network link module keys and resource addresses are retained, but
review the plan for every existing zone and link before applying. Older
AzureRM-based installations can require separate state migration; consult the
[historical migration guidance](https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones/blob/v0.23.2/_header.md)
and verify it against the actual source version and state. No automatic
migration is guaranteed for every historical installation.

Older versions such as `0.7.0` accepted `resource_group_name` and could create
the resource group. This version instead requires the resource ID of an
existing resource group in `parent_id`; callers must manage that group
separately. Existing deployments need an explicit, reviewed state migration
for the group and any affected zones and links.

The resource group role assignment names retain the earlier deterministic
UUID calculation for role names resolved by the interfaces module. Check the
planned names against existing assignments, including the exact casing of
principal and role definition IDs: UUID inputs are case-sensitive. States
created from intermediate, unreleased configurations using random names may
need separate migration. The DNS dependency's own role-assignment UUID
compatibility has the same case sensitivity, although this pattern does not
configure DNS-zone role assignments.

Telemetry now uses subscription-scope Azure deployments rather than ModTM.
The existing required `location` is forwarded to the private DNS module;
`enable_telemetry = false` disables telemetry in the pattern and its
dependencies. With telemetry enabled, the deployment identity needs
`Microsoft.Resources/deployments/read`, `write`, and `delete` at subscription
scope. Existing ModTM and telemetry-only random UUID state is forgotten without
destroying it; Terraform may need the old providers available for the first
initialization and migration plan. Review the plan before applying.

---

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.
