# terraform-azurerm-avm-ptn-network-private-link-private-dns-zones

This module deploys all known Azure Private DNS Zones for Azure Services that support Private Link as documented and detailed here in [Azure Private Endpoint private DNS zone values](https://learn.microsoft.com/azure/private-link/private-endpoint-dns). 

The module also has logic built in to it to handle the replacements of the following strings in the Private DNS Zone Names to the appropriate Azure Region name, short name or geo-code as required:

- `...{regionName}...`
- `...{regionCode}...`


> [!NOTE]  
> This module only supports Azure Public/Commercial today and **NOT** Azure US Government Cloud (a.k.a. Fairfax) or Azure China Cloud (a.k.a. Mooncake). If you would like to see support added for these clouds please raise an issue/feature request on this repo/module.

---

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.
