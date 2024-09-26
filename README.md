<!-- BEGIN_TF_DOCS -->
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

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the each of the Private Link Private DNS Zones created and Resource Group, if created, will be deployed.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed. Either the name of the new resource group to create or the name of an existing resource group.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for the Resource Group that hosts the Private DNS Zones. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_private_link_private_dns_zones"></a> [private\_link\_private\_dns\_zones](#input\_private\_link\_private\_dns\_zones)

Description: A set of Private Link Private DNS Zones to create. Each element must be a valid DNS zone name.

**NOTE:**

- Private Link Private DNS Zones that have `{{regionCode}}` in the name will be replaced with the Geo Code of the Region you specified in the `location` variable, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns#:~:text=Note-,In%20the%20above%20text%2C%20%7BregionCode%7D%20refers%20to%20the%20region%20code%20(for%20example%2C%20eus%20for%20East%20US%20and%20ne%20for%20North%20Europe).%20Refer%20to%20the%20following%20lists%20for%20regions%20codes%3A,-All%20public%20clouds).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` variable, `{{regionCode}}` would be replaced with `uks` in the Private DNS Zone name.
- Private Link Private DNS Zones that have `{{regionName}}` in the name will be replaced with the short name of the Region you specified in the `location` variable, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` variable, `{{regionName}}` would be replaced with `uksouth` in the Private DNS Zone name.

**IMPORTANT:**

The folowing Private Link Private DNS Zones have been removed from the default value for this variable as they require additional placeholders to be replaced that will only be known by the caller of the module at runtime and cannot be determined by the module itself. If you have a requirement to create these Private Link Private DNS Zones, you must provide the full list of Private Link Private DNS Zones to create as a set in the `private_link_private_dns_zones` variable, using the default value as a reference. The list of Private Link Private DNS Zones that have been removed are:

- `{subzone}.privatelink.{regionName}.azmk8s.io`
- `privatelink.{dnsPrefix}.database.windows.net`
- `privatelink.{partitionId}.azurestaticapps.net`

We have also removed the following Private Link Private DNS Zones from the default value for this variable as they should only be created and used with in specific scenarios:

- `privatelink.azure.com`

Type:

```hcl
map(object({
    zone_name = optional(string, null)
  }))
```

Default:

```json
{
  "azure_acr_data": {
    "zone_name": "{regionName}.data.privatelink.azurecr.io"
  },
  "azure_acr_registry": {
    "zone_name": "privatelink.azurecr.io"
  },
  "azure_ai_cog_svcs": {
    "zone_name": "privatelink.cognitiveservices.azure.com"
  },
  "azure_ai_oai": {
    "zone_name": "privatelink.openai.azure.com"
  },
  "azure_aks_mgmt": {
    "zone_name": "privatelink.{regionName}.azmk8s.io"
  },
  "azure_api_management": {
    "zone_name": "privatelink.azure-api.net"
  },
  "azure_app_configuration": {
    "zone_name": "privatelink.azconfig.io"
  },
  "azure_app_service": {
    "zone_name": "privatelink.azurewebsites.net"
  },
  "azure_app_service_scm": {
    "zone_name": "scm.privatelink.azurewebsites.net"
  },
  "azure_arc_guest_configuration": {
    "zone_name": "privatelink.guestconfiguration.azure.com"
  },
  "azure_arc_hybrid_compute": {
    "zone_name": "privatelink.his.arc.azure.com"
  },
  "azure_arc_kubernetes": {
    "zone_name": "privatelink.dp.kubernetesconfiguration.azure.com"
  },
  "azure_attestation": {
    "zone_name": "privatelink.attest.azure.net"
  },
  "azure_automation": {
    "zone_name": "privatelink.azure-automation.net"
  },
  "azure_avd_feed_mgmt": {
    "zone_name": "privatelink.wvd.microsoft.com"
  },
  "azure_avd_global": {
    "zone_name": "privatelink-global.wvd.microsoft.com"
  },
  "azure_backup": {
    "zone_name": "privatelink.{regionCode}.backup.windowsazure.com"
  },
  "azure_batch_account": {
    "zone_name": "{regionName}.privatelink.batch.azure.com"
  },
  "azure_batch_node_mgmt": {
    "zone_name": "{regionName}.service.privatelink.batch.azure.com"
  },
  "azure_bot_svc_bot": {
    "zone_name": "privatelink.directline.botframework.com"
  },
  "azure_bot_svc_token": {
    "zone_name": "privatelink.token.botframework.com"
  },
  "azure_cosmos_db_analytical": {
    "zone_name": "privatelink.analytics.cosmos.azure.com"
  },
  "azure_cosmos_db_cassandra": {
    "zone_name": "privatelink.cassandra.cosmos.azure.com"
  },
  "azure_cosmos_db_gremlin": {
    "zone_name": "privatelink.gremlin.cosmos.azure.com"
  },
  "azure_cosmos_db_mongo": {
    "zone_name": "privatelink.mongo.cosmos.azure.com"
  },
  "azure_cosmos_db_postgres": {
    "zone_name": "privatelink.postgres.cosmos.azure.com"
  },
  "azure_cosmos_db_sql": {
    "zone_name": "privatelink.documents.azure.com"
  },
  "azure_cosmos_db_table": {
    "zone_name": "privatelink.table.cosmos.azure.com"
  },
  "azure_data_explorer": {
    "zone_name": "privatelink.{regionName}.kusto.windows.net"
  },
  "azure_data_factory": {
    "zone_name": "privatelink.datafactory.azure.net"
  },
  "azure_data_factory_portal": {
    "zone_name": "privatelink.adf.azure.com"
  },
  "azure_data_lake_gen2": {
    "zone_name": "privatelink.dfs.core.windows.net"
  },
  "azure_databricks_ui_api": {
    "zone_name": "privatelink.azuredatabricks.net"
  },
  "azure_digital_twins": {
    "zone_name": "privatelink.digitaltwins.azure.net"
  },
  "azure_event_grid": {
    "zone_name": "privatelink.eventgrid.azure.net"
  },
  "azure_file_sync": {
    "zone_name": "privatelink.afs.azure.net"
  },
  "azure_grafana": {
    "zone_name": "privatelink.grafana.azure.com"
  },
  "azure_hdinsight": {
    "zone_name": "privatelink.azurehdinsight.net"
  },
  "azure_healthcare_dicom": {
    "zone_name": "privatelink.dicom.azurehealthcareapis.com"
  },
  "azure_healthcare_fhir": {
    "zone_name": "privatelink.fhir.azurehealthcareapis.com"
  },
  "azure_healthcare_workspaces": {
    "zone_name": "privatelink.workspace.azurehealthcareapis.com"
  },
  "azure_iot_central": {
    "zone_name": "privatelink.azureiotcentral.com"
  },
  "azure_iot_hub": {
    "zone_name": "privatelink.azure-devices.net"
  },
  "azure_iot_hub_provisioning": {
    "zone_name": "privatelink.azure-devices-provisioning.net"
  },
  "azure_iot_hub_update": {
    "zone_name": "privatelink.api.adu.microsoft.com"
  },
  "azure_key_vault": {
    "zone_name": "privatelink.vaultcore.azure.net"
  },
  "azure_log_analytics": {
    "zone_name": "privatelink.oms.opinsights.azure.com"
  },
  "azure_log_analytics_data": {
    "zone_name": "privatelink.ods.opinsights.azure.com"
  },
  "azure_managed_hsm": {
    "zone_name": "privatelink.managedhsm.azure.net"
  },
  "azure_maria_db_server": {
    "zone_name": "privatelink.mariadb.database.azure.com"
  },
  "azure_media_services_delivery": {
    "zone_name": "privatelink.media.azure.net"
  },
  "azure_migration_service": {
    "zone_name": "privatelink.prod.migration.windowsazure.com"
  },
  "azure_ml": {
    "zone_name": "privatelink.api.azureml.ms"
  },
  "azure_ml_notebooks": {
    "zone_name": "privatelink.notebooks.azure.net"
  },
  "azure_monitor": {
    "zone_name": "privatelink.monitor.azure.com"
  },
  "azure_monitor_agent": {
    "zone_name": "privatelink.agentsvc.azure-automation.net"
  },
  "azure_mysql_db_server": {
    "zone_name": "privatelink.mysql.database.azure.com"
  },
  "azure_postgres_sql_server": {
    "zone_name": "privatelink.postgres.database.azure.com"
  },
  "azure_power_bi_dedicated": {
    "zone_name": "privatelink.pbidedicated.windows.net"
  },
  "azure_power_bi_power_query": {
    "zone_name": "privatelink.tip1.powerquery.microsoft.com"
  },
  "azure_power_bi_tenant_analysis": {
    "zone_name": "privatelink.analysis.windows.net"
  },
  "azure_purview_account": {
    "zone_name": "privatelink.purview.azure.com"
  },
  "azure_purview_studio": {
    "zone_name": "privatelink.purviewstudio.azure.com"
  },
  "azure_redis_cache": {
    "zone_name": "privatelink.redis.cache.windows.net"
  },
  "azure_redis_enterprise": {
    "zone_name": "privatelink.redisenterprise.cache.azure.net"
  },
  "azure_search": {
    "zone_name": "privatelink.search.windows.net"
  },
  "azure_service_hub": {
    "zone_name": "privatelink.servicebus.windows.net"
  },
  "azure_signalr_service": {
    "zone_name": "privatelink.service.signalr.net"
  },
  "azure_site_recovery": {
    "zone_name": "privatelink.siterecovery.windowsazure.com"
  },
  "azure_sql_server": {
    "zone_name": "privatelink.database.windows.net"
  },
  "azure_static_web_apps": {
    "zone_name": "privatelink.azurestaticapps.net"
  },
  "azure_storage_blob": {
    "zone_name": "privatelink.blob.core.windows.net"
  },
  "azure_storage_file": {
    "zone_name": "privatelink.file.core.windows.net"
  },
  "azure_storage_queue": {
    "zone_name": "privatelink.queue.core.windows.net"
  },
  "azure_storage_table": {
    "zone_name": "privatelink.table.core.windows.net"
  },
  "azure_storage_web": {
    "zone_name": "privatelink.web.core.windows.net"
  }
}
```

### <a name="input_resource_group_creation_enabled"></a> [resource\_group\_creation\_enabled](#input\_resource\_group\_creation\_enabled)

Description: This variable controls whether or not the resource group should be created. If set to false, the resource group must be created elsewhere and the resource group name must be provided to the module. If set to true, the resource group will be created by the module using the name provided in `resource_group_name`.

Type: `bool`

Default: `true`

### <a name="input_resource_group_role_assignments"></a> [resource\_group\_role\_assignments](#input\_resource\_group\_role\_assignments)

Description: A map of role assignments to create on the Resource Group. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

### <a name="input_virtual_network_resource_ids_to_link_to"></a> [virtual\_network\_resource\_ids\_to\_link\_to](#input\_virtual\_network\_resource\_ids\_to\_link\_to)

Description: A map of objects of Virtual Network Resource IDs to link to the Private Link Private DNS Zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `vnet_resource_id` - (Optional) The resource ID of the Virtual Network to link to the Private Link Private DNS Zones created to.

Type:

```hcl
map(object({
    vnet_resource_id = optional(string, null)
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_combined_private_link_private_dns_zones_replaced_with_vnets_to_link"></a> [combined\_private\_link\_private\_dns\_zones\_replaced\_with\_vnets\_to\_link](#output\_combined\_private\_link\_private\_dns\_zones\_replaced\_with\_vnets\_to\_link)

Description: The final map of private link private DNS zones to link to virtual networks including the region name replacements as required.

### <a name="output_resource_group_resource_id"></a> [resource\_group\_resource\_id](#output\_resource\_group\_resource\_id)

Description: The resource ID of the resource group that the Private DNS Zones are deployed into.

## Modules

The following Modules are called:

### <a name="module_avm_res_network_privatednszone"></a> [avm\_res\_network\_privatednszone](#module\_avm\_res\_network\_privatednszone)

Source: Azure/avm-res-network-privatednszone/azurerm

Version: 0.1.2

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->