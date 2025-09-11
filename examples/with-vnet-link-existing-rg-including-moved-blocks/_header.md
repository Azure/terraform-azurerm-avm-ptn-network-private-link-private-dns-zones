# Link Private DNS Zones to Virtual Networks and Deploy Private DNS Zones to an Existing Resource Group - Including Moved Blocks from Versions `v0.17.0` and prior

This deploys the in a more advanced but more common configuration.

It will deploy all known Azure Private DNS Zones for Azure Services that support Private Link into an existing Resource Group and will also link each of the Private DNS Zones to the Virtual Networks provided via a Private DNS Zone Virtual Network Link.

It also includes moved blocks to assist with upgrading from versions `v0.17.0` and prior of the module. These can be used as a reference for how to create your own moved blocks if you are upgrading from these earlier versions of the module. Checkout them in the `moved` blocks at the bottom of the `main.tf` file.
