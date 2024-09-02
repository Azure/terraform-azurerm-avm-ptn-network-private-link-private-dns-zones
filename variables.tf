variable "location" {
  type        = string
  description = "Azure region where the each of the Private Link Private DNS Zones created and Resource Group, if created, will be deployed."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed. Either the name of the new resource group to create or the name of an existing resource group."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for the Resource Group that hosts the Private DNS Zones. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "private_link_private_dns_zones" {
  type = map(object({
    zone_name = optional(string, null)
  }))
  default = {
    azure_ml = {
      zone_name = "privatelink.api.azureml.ms"
    }
    azure_ml_notebooks = {
      zone_name = "privatelink.notebooks.azure.net"
    }
    azure_ai_cog_svcs = {
      zone_name = "privatelink.cognitiveservices.azure.com"
    }
    azure_ai_oai = {
      zone_name = "privatelink.openai.azure.com"
    }
    azure_bot_svc_bot = {
      zone_name = "privatelink.directline.botframework.com"
    }
    azure_bot_svc_token = {
      zone_name = "privatelink.token.botframework.com"
    }
    azure_service_hub = {
      zone_name = "privatelink.servicebus.windows.net"
    }
    azure_data_factory = {
      zone_name = "privatelink.datafactory.azure.net"
    }
    azure_data_factory_portal = {
      zone_name = "privatelink.adf.azure.com"
    }
    azure_hdinsight = {
      zone_name = "privatelink.azurehdinsight.net"
    }
    azure_data_explorer = {
      zone_name = "privatelink.{regionName}.kusto.windows.net"
    }
    azure_storage_blob = {
      zone_name = "privatelink.blob.core.windows.net"
    }
    azure_storage_queue = {
      zone_name = "privatelink.queue.core.windows.net"
    }
    azure_storage_table = {
      zone_name = "privatelink.table.core.windows.net"
    }
    azure_storage_file = {
      zone_name = "privatelink.file.core.windows.net"
    }
    azure_storage_web = {
      zone_name = "privatelink.web.core.windows.net"
    }
    azure_data_lake_gen2 = {
      zone_name = "privatelink.dfs.core.windows.net"
    }
    azure_file_sync = {
      zone_name = "privatelink.afs.azure.net"
    }
    azure_power_bi_tenant_analysis = {
      zone_name = "privatelink.analysis.windows.net"
    }
    azure_power_bi_dedicated = {
      zone_name = "privatelink.pbidedicated.windows.net"
    }
    azure_power_bi_power_query = {
      zone_name = "privatelink.tip1.powerquery.microsoft.com"
    }
    azure_databricks_ui_api = {
      zone_name = "privatelink.azuredatabricks.net"
    }
    azure_batch_account = {
      zone_name = "{regionName}.privatelink.batch.azure.com"
    }
    azure_batch_node_mgmt = {
      zone_name = "{regionName}.service.privatelink.batch.azure.com"
    }
    azure_avd_global = {
      zone_name = "privatelink-global.wvd.microsoft.com"
    }
    azure_avd_feed_mgmt = {
      zone_name = "privatelink.wvd.microsoft.com"
    }
    azure_aks_mgmt = {
      zone_name = "privatelink.{regionName}.azmk8s.io"
    }
    azure_acr_registry = {
      zone_name = "privatelink.azurecr.io"
    }
    azure_acr_data = {
      zone_name = "{regionName}.data.privatelink.azurecr.io"
    }
    azure_sql_server = {
      zone_name = "privatelink.database.windows.net"
    }
    azure_cosmos_db_sql = {
      zone_name = "privatelink.documents.azure.com"
    }
    azure_cosmos_db_mongo = {
      zone_name = "privatelink.mongo.cosmos.azure.com"
    }
    azure_cosmos_db_cassandra = {
      zone_name = "privatelink.cassandra.cosmos.azure.com"
    }
    azure_cosmos_db_gremlin = {
      zone_name = "privatelink.gremlin.cosmos.azure.com"
    }
    azure_cosmos_db_table = {
      zone_name = "privatelink.table.cosmos.azure.com"
    }
    azure_cosmos_db_analytical = {
      zone_name = "privatelink.analytics.cosmos.azure.com"
    }
    azure_cosmos_db_postgres = {
      zone_name = "privatelink.postgres.cosmos.azure.com"
    }
    azure_maria_db_server = {
      zone_name = "privatelink.mariadb.database.azure.com"
    }
    azure_postgres_sql_server = {
      zone_name = "privatelink.postgres.database.azure.com"
    }
    azure_mysql_db_server = {
      zone_name = "privatelink.mysql.database.azure.com"
    }
    azure_redis_cache = {
      zone_name = "privatelink.redis.cache.windows.net"
    }
    azure_redis_enterprise = {
      zone_name = "privatelink.redisenterprise.cache.azure.net"
    }
    azure_arc_hybrid_compute = {
      zone_name = "privatelink.his.arc.azure.com"
    }
    azure_arc_guest_configuration = {
      zone_name = "privatelink.guestconfiguration.azure.com"
    }
    azure_arc_kubernetes = {
      zone_name = "privatelink.dp.kubernetesconfiguration.azure.com"
    }
    azure_event_grid = {
      zone_name = "privatelink.eventgrid.azure.net"
    }
    azure_api_management = {
      zone_name = "privatelink.azure-api.net"
    }
    azure_healthcare_workspaces = {
      zone_name = "privatelink.workspace.azurehealthcareapis.com"
    }
    azure_healthcare_fhir = {
      zone_name = "privatelink.fhir.azurehealthcareapis.com"
    }
    azure_healthcare_dicom = {
      zone_name = "privatelink.dicom.azurehealthcareapis.com"
    }
    azure_iot_hub = {
      zone_name = "privatelink.azure-devices.net"
    }
    azure_iot_hub_provisioning = {
      zone_name = "privatelink.azure-devices-provisioning.net"
    }
    azure_iot_hub_update = {
      zone_name = "privatelink.api.adu.microsoft.com"
    }
    azure_iot_central = {
      zone_name = "privatelink.azureiotcentral.com"
    }
    azure_digital_twins = {
      zone_name = "privatelink.digitaltwins.azure.net"
    }
    azure_media_services_delivery = {
      zone_name = "privatelink.media.azure.net"
    }
    azure_automation = {
      zone_name = "privatelink.azure-automation.net"
    }
    azure_backup = {
      zone_name = "privatelink.{regionCode}.backup.windowsazure.com"
    }
    azure_site_recovery = {
      zone_name = "privatelink.siterecovery.windowsazure.com"
    }
    azure_monitor = {
      zone_name = "privatelink.monitor.azure.com"
    }
    azure_log_analytics = {
      zone_name = "privatelink.oms.opinsights.azure.com"
    }
    azure_log_analytics_data = {
      zone_name = "privatelink.ods.opinsights.azure.com"
    }
    azure_monitor_agent = {
      zone_name = "privatelink.agentsvc.azure-automation.net"
    }
    azure_purview_account = {
      zone_name = "privatelink.purview.azure.com"
    }
    azure_purview_studio = {
      zone_name = "privatelink.purviewstudio.azure.com"
    }
    azure_migration_service = {
      zone_name = "privatelink.prod.migration.windowsazure.com"
    }
    azure_grafana = {
      zone_name = "privatelink.grafana.azure.com"
    }
    azure_key_vault = {
      zone_name = "privatelink.vaultcore.azure.net"
    }
    azure_managed_hsm = {
      zone_name = "privatelink.managedhsm.azure.net"
    }
    azure_app_configuration = {
      zone_name = "privatelink.azconfig.io"
    }
    azure_attestation = {
      zone_name = "privatelink.attest.azure.net"
    }
    azure_search = {
      zone_name = "privatelink.search.windows.net"
    }
    azure_app_service = {
      zone_name = "privatelink.azurewebsites.net"
    }
    azure_app_service_scm = {
      zone_name = "scm.privatelink.azurewebsites.net"
    }
    azure_signalr_service = {
      zone_name = "privatelink.service.signalr.net"
    }
    azure_static_web_apps = {
      zone_name = "privatelink.azurestaticapps.net"
    }
  }
  description = <<DESCRIPTION
A set of Private Link Private DNS Zones to create. Each element must be a valid DNS zone name.

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

DESCRIPTION
  nullable    = false
}

variable "resource_group_creation_enabled" {
  type        = bool
  default     = true
  description = "This variable controls whether or not the resource group should be created. If set to false, the resource group must be created elsewhere and the resource group name must be provided to the module. If set to true, the resource group will be created by the module using the name provided in `resource_group_name`."
  nullable    = false
}

variable "resource_group_role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the Resource Group. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "virtual_network_resource_ids_to_link_to" {
  type = map(object({
    vnet_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of objects of Virtual Network Resource IDs to link to the Private Link Private DNS Zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `vnet_resource_id` - (Optional) The resource ID of the Virtual Network to link to the Private Link Private DNS Zones created to.

DESCRIPTION  
  nullable    = false
}
