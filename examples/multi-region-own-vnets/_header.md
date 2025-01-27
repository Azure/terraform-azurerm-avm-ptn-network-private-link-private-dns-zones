# Deploys Private Link DNS Zones to multiple regions and link with their own vNets

This deploys the in a more advanced configuration and also allows a scale test.

It will deploy all known Azure Private DNS Zones for Azure Services that support Private Link into an existing Resource Group and will also link each of the Private DNS Zones to the Virtual Networks provided via a Private DNS Zone Virtual Network Link once in each region in the test.
