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
    zone_name  = optional(string, null)
    groups_ids = optional(list(string), null)
  }))
  default = {
    azure_ml = {
      zone_name = "privatelink.api.azureml.ms"
      groups_ids = [
        "amlworkspace"
      ]
    }
    azure_ml_notebooks = {
      zone_name = "privatelink.notebooks.azure.net"
      groups_ids = [
        "amlworkspace"
      ]
    }
    azure_ai_cog_svcs = {
      zone_name = "privatelink.cognitiveservices.azure.com"
      groups_ids = [
        "account"
      ]
    }
    azure_ai_oai = {
      zone_name = "privatelink.openai.azure.com"
      groups_ids = [
        "account"
      ]
    }
    azure_bot_svc_bot = {
      zone_name = "privatelink.directline.botframework.com"
      groups_ids = [
        "Bot"
      ]
    }
    azure_bot_svc_token = {
      zone_name = "privatelink.token.botframework.com"
      groups_ids = [
        "Token"
      ]
    }
    azure_service_hub = {
      zone_name = "privatelink.servicebus.windows.net"
      groups_ids = [
        "namespace"
      ]
    }
    azure_data_factory = {
      zone_name = "privatelink.datafactory.azure.net"
      groups_ids = [
        "dataFactory"
      ]
    }
    azure_data_factory_portal = {
      zone_name = "privatelink.adf.azure.com"
      groups_ids = [
        "portal"
      ]
    }
    azure_hdinsight = {
      zone_name = "privatelink.azurehdinsight.net"
      groups_ids = [
        "gateway",
        "headnode"
      ]
    }
    azure_data_explorer = {
      zone_name = "privatelink.{regionName}.kusto.windows.net"
      groups_ids = [
        "cluster"
      ]
    }
    azure_storage_blob = {
      zone_name = "privatelink.blob.core.windows.net"
      groups_ids = [
        "blob",
        "blob_secondary",
        "disks",
        "azuremonitor"
      ]
    }
    azure_storage_queue = {
      zone_name = "privatelink.queue.core.windows.net"
      groups_ids = [
        "queue",
        "queue_secondary"
      ]
    }
    azure_storage_table = {
      zone_name = "privatelink.table.core.windows.net"
      groups_ids = [
        "table",
        "table_secondary"
      ]
    }
    azure_storage_file = {
      zone_name = "privatelink.file.core.windows.net"
      groups_ids = [
        "file",
        "file_secondary"
      ]
    }
    azure_storage_web = {
      zone_name = "privatelink.web.core.windows.net"
      groups_ids = [
        "web",
        "web_secondary"
      ]
    }
    azure_data_lake_gen2 = {
      zone_name = "privatelink.dfs.core.windows.net"
      groups_ids = [
        "dfs",
        "dfs_secondary"
      ]
    }
    azure_file_sync = {
      zone_name = "privatelink.afs.azure.net"
      groups_ids = [
        "afs"
      ]
    }
    azure_power_bi_tenant_analysis = {
      zone_name = "privatelink.analysis.windows.net"
      groups_ids = [
        "tenant"
      ]
    }
    azure_power_bi_dedicated = {
      zone_name = "privatelink.pbidedicated.windows.net"
      groups_ids = [
        "tenant"
      ]
    }
    azure_power_bi_power_query = {
      zone_name = "privatelink.tip1.powerquery.microsoft.com"
      groups_ids = [
        "tenant"
      ]
    }
    azure_databricks_ui_api = {
      zone_name = "privatelink.azuredatabricks.net"
      groups_ids = [
        "databricks_ui_api",
        "browser_authentication"
      ]
    }
    azure_batch = {
      zone_name = "privatelink.batch.azure.com"
      groups_ids = [
        "batchAccount",
        "nodeManagement"
      ]
    }
    azure_avd_global = {
      zone_name = "privatelink-global.wvd.microsoft.com"
      groups_ids = [
        "global"
      ]
    }
    azure_avd_feed_mgmt = {
      zone_name = "privatelink.wvd.microsoft.com"
      groups_ids = [
        "feed",
        "connection"
      ]
    }
    azure_aks_mgmt = {
      zone_name = "privatelink.{regionName}.azmk8s.io"
      groups_ids = [
        "management"
      ]
    }
    azure_acr_registry = {
      zone_name = "privatelink.azurecr.io"
      groups_ids = [
        "registry"
      ]
    }
    azure_acr_data = {
      zone_name = "{regionName}.data.privatelink.azurecr.io"
      groups_ids = [
        "registry"
      ]
    }
    azure_sql_server = {
      zone_name = "privatelink.database.windows.net"
      groups_ids = [
        "sqlServer"
      ]
    }
    azure_cosmos_db_sql = {
      zone_name = "privatelink.documents.azure.com"
      groups_ids = [
        "Sql"
      ]
    }
    azure_cosmos_db_mongo = {
      zone_name = "privatelink.mongo.cosmos.azure.com"
      groups_ids = [
        "MongoDB"
      ]
    }
    azure_cosmos_db_cassandra = {
      zone_name = "privatelink.cassandra.cosmos.azure.com"
      groups_ids = [
        "Cassandra"
      ]
    }
    azure_cosmos_db_gremlin = {
      zone_name = "privatelink.gremlin.cosmos.azure.com"
      groups_ids = [
        "Gremlin"
      ]
    }
    azure_cosmos_db_table = {
      zone_name = "privatelink.table.cosmos.azure.com"
      groups_ids = [
        "Table"
      ]
    }
    azure_cosmos_db_analytical = {
      zone_name = "privatelink.analytics.cosmos.azure.com"
      groups_ids = [
        "Analytical"
      ]
    }
    azure_cosmos_db_postgres = {
      zone_name = "privatelink.postgres.cosmos.azure.com"
      groups_ids = [
        "coordinator"
      ]
    }
    azure_maria_db_server = {
      zone_name = "privatelink.mariadb.database.azure.com"
      groups_ids = [
        "mariadbServer"
      ]
    }
    azure_postgres_sql_server = {
      zone_name = "privatelink.postgres.database.azure.com"
      groups_ids = [
        "postgresqlServer"
      ]
    }
    azure_mysql_db_server = {
      zone_name = "privatelink.mysql.database.azure.com"
      groups_ids = [
        "mysqlServer"
      ]
    }
    azure_redis_cache = {
      zone_name = "privatelink.redis.cache.windows.net"
      groups_ids = [
        "redisCache"
      ]
    }
    azure_redis_enterprise = {
      zone_name = "privatelink.redisenterprise.cache.azure.net"
      groups_ids = [
        "redisEnterprise"
      ]
    }
    azure_arc_hybrid_compute = {
      zone_name = "privatelink.his.arc.azure.com"
      groups_ids = [
        "hybridcompute"
      ]
    }
    azure_arc_guest_configuration = {
      zone_name = "privatelink.guestconfiguration.azure.com"
      groups_ids = [
        "hybridcompute"
      ]
    }
    azure_arc_kubernetes = {
      zone_name = "privatelink.dp.kubernetesconfiguration.azure.com"
      groups_ids = [
        "hybridcompute"
      ]
    }
    azure_event_grid = {
      zone_name = "privatelink.eventgrid.azure.net"
      groups_ids = [
        "topic",
        "domain",
        "partnernamespace"
      ]
    }
    azure_api_management = {
      zone_name = "privatelink.azure-api.net"
      groups_ids = [
        "Gateway"
      ]
    }
    azure_healthcare_workspaces = {
      zone_name = "privatelink.workspace.azurehealthcareapis.com"
      groups_ids = [
        "healthcareworkspace"
      ]
    }
    azure_healthcare_fhir = {
      zone_name = "privatelink.fhir.azurehealthcareapis.com"
      groups_ids = [
        "healthcareworkspace"
      ]
    }
    azure_healthcare_dicom = {
      zone_name = "privatelink.dicom.azurehealthcareapis.com"
      groups_ids = [
        "healthcareworkspace"
      ]
    }
    azure_iot_hub = {
      zone_name = "privatelink.azure-devices.net"
      groups_ids = [
        "iotHub"
      ]
    }
    azure_iot_hub_provisioning = {
      zone_name = "privatelink.azure-devices-provisioning.net"
      groups_ids = [
        "iotDps"
      ]
    }
    azure_iot_hub_update = {
      zone_name = "privatelink.api.adu.microsoft.com"
      groups_ids = [
        "DeviceUpdate"
      ]
    }
    azure_iot_central = {
      zone_name = "privatelink.azureiotcentral.com"
      groups_ids = [
        "iotApp"
      ]
    }
    azure_digital_twins = {
      zone_name = "privatelink.digitaltwins.azure.net"
      groups_ids = [
        "API"
      ]
    }
    azure_media_services_delivery = {
      zone_name = "privatelink.media.azure.net"
      groups_ids = [
        "keydelivery",
        "liveevent",
        "streamingendpoint"
      ]
    }
    azure_automation = {
      zone_name = "privatelink.azure-automation.net"
      groups_ids = [
        "Webhook",
        "DSCAndHybridWorker"
      ]
    }
    azure_backup = {
      zone_name = "privatelink.{regionCode}.backup.windowsazure.com"
      groups_ids = [
        "AzureBackup"
      ]
    }
    azure_site_recovery = {
      zone_name = "privatelink.siterecovery.windowsazure.com"
      groups_ids = [
        "AzureSiteRecovery"
      ]
    }
    azure_monitor = {
      zone_name = "privatelink.monitor.azure.com"
      groups_ids = [
        "azuremonitor"
      ]
    }
    azure_log_analytics = {
      zone_name = "privatelink.oms.opinsights.azure.com"
      groups_ids = [
        "azuremonitor"
      ]
    }
    azure_log_analytics_data = {
      zone_name = "privatelink.ods.opinsights.azure.com"
      groups_ids = [
        "azuremonitor"
      ]
    }
    azure_monitor_agent = {
      zone_name = "privatelink.agentsvc.azure-automation.net"
      groups_ids = [
        "azuremonitor"
      ]
    }
    azure_purview_account = {
      zone_name = "privatelink.purview.azure.com"
      groups_ids = [
        "account"
      ]
    }
    azure_purview_studio = {
      zone_name = "privatelink.purviewstudio.azure.com"
      groups_ids = [
        "portal"
      ]
    }
    azure_migration_service = {
      zone_name = "privatelink.prod.migration.windowsazure.com"
      groups_ids = [
        "Default"
      ]
    }
    azure_grafana = {
      zone_name = "privatelink.grafana.azure.com"
      groups_ids = [
        "grafana"
      ]
    }
    azure_key_vault = {
      zone_name = "privatelink.vaultcore.azure.net"
      groups_ids = [
        "vault"
      ]
    }
    azure_managed_hsm = {
      zone_name = "privatelink.managedhsm.azure.net"
      groups_ids = [
        "managedhsm"
      ]
    }
    azure_app_configuration = {
      zone_name = "privatelink.azconfig.io"
      groups_ids = [
        "configurationStores"
      ]
    }
    azure_attestation = {
      zone_name = "privatelink.attest.azure.net"
      groups_ids = [
        "standard"
      ]
    }
    azure_search = {
      zone_name = "privatelink.search.windows.net"
      groups_ids = [
        "searchService"
      ]
    }
    azure_app_service = {
      zone_name = "privatelink.azurewebsites.net"
      groups_ids = [
        "sites"
      ]
    }
    azure_app_service_scm = {
      zone_name = "scm.privatelink.azurewebsites.net"
      groups_ids = [
        "sites"
      ]
    }
    azure_signalr_service = {
      zone_name = "privatelink.service.signalr.net"
      groups_ids = [
        "signalr"
      ]
    }
    azure_static_web_apps = {
      zone_name = "privatelink.azurestaticapps.net"
      groups_ids = [
        "staticSites"
      ]
    }
    azure_synapse_sql = {
      zone_name = "privatelink.sql.azuresynapse.net"
      groups_ids = [
        "Sql",
        "SqlOnDemand"
      ]
    }
    azure_synapse_dev = {
      zone_name = "privatelink.dev.azuresynapse.net"
      groups_ids = [
        "Dev"
      ]
    }
    azure_web_pubsub = {
      zone_name = "privatelink.webpubsub.azure.com"
      groups_ids = [
        "webpubsub"
      ]
    }
  }
  description = <<DESCRIPTION
A set of Private Link Private DNS Zones to create, along with the private endpoint groupIds associated with them. Each element must be a valid DNS zone name.

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

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "timeouts" {
  type = object({
    dns_zones = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
      }), {}
    )
    vnet_links = optional(object({
      create = optional(string, "30m")
      delete = optional(string, "30m")
      update = optional(string, "30m")
      read   = optional(string, "5m")
      }), {}
    )
  })
  default     = {}
  description = <<DESCRIPTION
A map of timeouts objects, per resource type, to apply to the creation and destruction of resources the following resources:

- `dns_zones` - (Optional) The timeouts for DNS Zones.
- `vnet_links` - (Optional) The timeouts for DNS Zones Virtual Network Links.

Each timeout object has the following optional attributes:

- `create` - (Optional) The timeout for creating the resource. Defaults to `5m` apart from policy assignments, where this is set to `15m`.
- `delete` - (Optional) The timeout for deleting the resource. Defaults to `5m`.
- `update` - (Optional) The timeout for updating the resource. Defaults to `5m`.
- `read` - (Optional) The timeout for reading the resource. Defaults to `5m`.

DESCRIPTION
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
