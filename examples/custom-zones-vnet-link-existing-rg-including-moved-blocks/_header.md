# Link Private DNS Zones to Virtual Networks and Deploy Private DNS Zones to an Existing Resource Group - Including Moved Blocks from Versions `v0.17.0` and prior

This deploys the module in a more advanced and rarer configuration.

It will deploy custom private DNS zones into an existing Resource Group and will also link each of the Private DNS Zones to the Virtual Networks provided via a Private DNS Zone Virtual Network Link.

Also tags are added to all resources created by the module.

It also includes moved blocks to assist with upgrading from versions `v0.17.0` and prior of the module. These can be used as a reference for how to create your own moved blocks if you are upgrading from these earlier versions of the module. Checkout them in the `moved` blocks at the bottom of the `main.tf` file.
