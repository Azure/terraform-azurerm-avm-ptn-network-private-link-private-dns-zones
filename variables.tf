variable "location" {
  type        = string
  description = "Azure region where each of the private link private DNS zones and Resource Group, if created, will be deployed."
  nullable    = false
}

variable "parent_id" {
  type        = string
  description = "The resource ID of the existing Resource Group. e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`."

  validation {
    condition = (
      can(regex("^/subscriptions/[0-9a-fA-F-]{36}/resourceGroups/[A-Za-z0-9._()-]*[A-Za-z0-9_()-]$", var.parent_id))
      && length(split("/", var.parent_id)[4]) <= 90
    )
    error_message = "The provided parent_id_existing_resource_group must be a valid resource group resource ID with a name that is 1-90 characters, uses only letters, numbers, `.`, `_`, `(', ')`, or `-`, and does not end with a period, or `null`. e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for the Resource Group that hosts the private link private DNS zones. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "private_link_excluded_zones" {
  type        = set(string)
  default     = []
  description = "A set of private link private DNS zones to exclude. Either DNS zone names or the `private_link_private_dns_zones` map key name (e.g. 'azure_ml') must match what is provided as the default values or any input to the private_link_private_dns_zones parameter e.g. privatelink.api.azureml.ms or privatelink.{regionCode}.backup.windowsazure.com or azure_ml."
}

variable "private_link_private_dns_zones" {
  type = map(object({
    zone_name                              = optional(string, null)
    private_dns_zone_supports_private_link = optional(bool, true)
    custom_iterator = optional(object({
      replacement_placeholder = string
      replacement_values      = map(string)
    }))
    resolution_policy = optional(string, null)
  }))
  default = {
    azure_container_apps = {
      zone_name = "privatelink.{regionName}.azurecontainerapps.io"
    }
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
    azure_ai_services = {
      zone_name = "privatelink.services.ai.azure.com"
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
    azure_fabric = {
      zone_name = "privatelink.fabric.microsoft.com"
    }
    azure_batch = {
      zone_name = "privatelink.batch.azure.com"
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
    azure_sql_server = {
      zone_name = "privatelink.database.windows.net"
    }
    azure_cosmos_db_sql = {
      zone_name = "privatelink.documents.azure.com"
    }
    azure_cosmos_db_mongo = {
      zone_name = "privatelink.mongo.cosmos.azure.com"
    }
    azure_cosmos_db_mongo_vcore = {
      zone_name = "privatelink.mongocluster.cosmos.azure.com"
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
    azure_healthcare = {
      zone_name = "privatelink.azurehealthcareapis.com"
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
    azure_managed_prometheus = {
      zone_name = "privatelink.{regionName}.prometheus.monitor.azure.com"
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
    azure_signalr_service = {
      zone_name = "privatelink.service.signalr.net"
    }
    azure_static_web_apps = {
      zone_name = "privatelink.azurestaticapps.net"
    }
    azure_static_web_apps_partitioned = {
      zone_name = "privatelink.{partitionId}.azurestaticapps.net"
      custom_iterator = {
        replacement_placeholder = "partitionId"
        replacement_values = {
          1 = "1"
          2 = "2"
          3 = "3"
          4 = "4"
          5 = "5"
        }
      }
    }
    azure_synapse = {
      zone_name = "privatelink.azuresynapse.net"
    }
    azure_synapse_sql = {
      zone_name = "privatelink.sql.azuresynapse.net"
    }
    azure_synapse_dev = {
      zone_name = "privatelink.dev.azuresynapse.net"
    }
    azure_web_pubsub = {
      zone_name = "privatelink.webpubsub.azure.com"
    }
  }
  description = <<DESCRIPTION
A set of private link private DNS zones to create. Each element must be a valid DNS zone name.

- `zone_name` - The name of the private link private DNS zone to create. This can include placeholders for the region code and region name, which will be replaced with the appropriate values based on the `location` variable.
- `private_dns_zone_supports_private_link` - (Optional) Whether the private link private DNS zone supports Private Link. Defaults to `true`.
- `custom_iterator` - (Optional) An object that defines a custom iterator for the private link private DNS zone. This is used to create multiple private link private DNS zones with the same base name but different replacements. The object must contain:
  - `replacement_placeholder` - The placeholder to replace in the `zone_name` with the custom replacement value.
  - `replacement_values` - A map of values to use for the custom iterator, where the value is the value to replace in the `zone_name`.
- `resolution_policy` - (Optional) The resolution policy for the private link private DNS zone to override the value specified in the `virtual_network_links` variable for a private link private DNS zone's virtual network link. Possible values are `Default` and `NxDomainRedirect`.

**NOTE:**

- Private link private DNS zones that have `{{regionCode}}` in the name will be replaced with the Geo Code of the Region you specified in the `location` variable, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns#:~:text=Note-,In%20the%20above%20text%2C%20%7BregionCode%7D%20refers%20to%20the%20region%20code%20(for%20example%2C%20eus%20for%20East%20US%20and%20ne%20for%20North%20Europe).%20Refer%20to%20the%20following%20lists%20for%20regions%20codes%3A,-All%20public%20clouds).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` variable, `{{regionCode}}` would be replaced with `uks` in the private link private DNS zone name.
- Private link private DNS zones that have `{{regionName}}` in the name will be replaced with the short name of the Region you specified in the `location` variable, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` variable, `{{regionName}}` would be replaced with `uksouth` in the private link private DNS zone name.

**IMPORTANT:**

The following private link private DNS zones have been removed from the default value for this variable as they require additional placeholders to be replaced that will only be known by the caller of the module at runtime and cannot be determined by the module itself. If you have a requirement to create these private link private DNS zones, you must provide the full list of private link private DNS zones to create as a set in the `private_link_private_dns_zones` variable, using the default value as a reference. The list of private link private DNS zones that have been removed are:

- `{subzone}.privatelink.{regionName}.azmk8s.io`
- `privatelink.{dnsPrefix}.database.windows.net`

We have also removed the following private link private DNS zones from the default value for this variable as they should only be created and used with in specific scenarios:

- `privatelink.azure.com`

DESCRIPTION
  nullable    = false
}

variable "private_link_private_dns_zones_additional" {
  type = map(object({
    zone_name                              = optional(string, null)
    private_dns_zone_supports_private_link = optional(bool, true)
    custom_iterator = optional(object({
      replacement_placeholder = string
      replacement_values      = map(string)
    }))
    resolution_policy = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A set of private link private DNS zones to create in addition to the zones supplied in `private_link_private_dns_zones`. Each element must be a valid DNS zone name.

The purpose of this variable is to allow the use of our default zones and just add any additional zones without having to redefine the entire set of default zones.

- `zone_name` - The name of the private link private DNS zone to create. This can include placeholders for the region code and region name, which will be replaced with the appropriate values based on the `location` variable.
- `private_dns_zone_supports_private_link` - (Optional) Whether the private link private DNS zone supports Private Link. Defaults to `true`.
- `custom_iterator` - (Optional) An object that defines a custom iterator for the private link private DNS zone. This is used to create multiple private link private DNS zones with the same base name but different replacements. The object must contain:
  - `replacement_placeholder` - The placeholder to replace in the `zone_name` with the custom iterator replacement value.
  - `replacement_values` - A map of values to use for the custom iterator, where the value is the value to replace in the `zone_name`.
- `resolution_policy` - (Optional) The resolution policy for the private link private DNS zone to override the value specified in the `virtual_network_links` variable for a private link private DNS zone's virtual network link. Possible values are `Default` and `NxDomainRedirect`.
DESCRIPTION
  nullable    = false
}

variable "private_link_private_dns_zones_regex_filter" {
  type = object({
    enabled      = optional(bool, false)
    regex_filter = optional(string, "{regionName}|{regionCode}")
  })
  default     = {}
  description = <<DESCRIPTION
This variable controls whether or not the private link private DNS zones should be filtered based on the zone name. If enabled, the `regex_filter` will be used to filter the private link private DNS zones based on the zone name.
- `enabled` - (Optional) Whether to enable filtering of the private link private DNS zones. Defaults to `false`.
- `regex_filter` - (Optional) The regular expression filter to apply to the private link private DNS zones. The default value is `{regionName}|{regionCode}`, which will filter for regional private link private DNS zones often needed for secondary regions. You can specify a custom filter to match your requirements.
DESCRIPTION
  nullable    = false
}

variable "resource_group_role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    principal_type                         = optional(string, null)
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
- `principal_type` - (Optional) The type of the principal. Possible values are `User`, `Group`, and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Entra ID check for the service principal in the tenant. Defaults to `false`.
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

variable "virtual_network_link_additional_virtual_networks" {
  type = map(object({
    virtual_network_resource_id                 = optional(string)
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of objects of Virtual Network Resource IDs to link to all the private link private DNS zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

This is merged with the `virtual_network_link_default_virtual_networks` variable. If a duplicate key is used, this variable will take precedence.

- `virtual_network_resource_id` - (Optional) The resource ID of the Virtual Network to link to the private link private DNS zones created to.
- `virtual_network_link_name_template_override` - (Optional) A template to override the default name of the virtual network link. If this option is not provided, the default of `var.virtual_network_link_name_template` will be used. The template can include the following placeholders:
    - `{zone_key}` - The map key of the private link private DNS zone.
    - `{vnet_name}` - The name of the virtual network.
    - `{vnet_key}` - The map key of the virtual network link.
    - `{location}` - The location of the resource group where the private link private DNS zone is created. In the case of multi-region deployment, this may refer to the primary region only. The `vnet_name` may be better suited to identify the VNet location in such cases.
- `resolution_policy` - (Optional) The resolution policy for the Virtual Network Link. Possible values are `Default` and `NxDomainRedirect`. If not specified, the value from `virtual_network_link_overrides_by_zone`, `virtual_network_link_overrides_by_virtual_network`, `virtual_network_link_overrides`, `private_link_dns_zones`, `private_link_dns_zones_additional`, or `virtual_network_link_resolution_policy_default` variable will be used in that precedence.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_by_zone_and_virtual_network" {
  type = map(map(object({
    virtual_network_resource_id = optional(string)
    name                        = optional(string)
    resolution_policy           = optional(string)
  })))
  default     = {}
  description = <<DESCRIPTION
A map of maps of objects of Virtual Network Resource IDs to link to specific private link private DNS zones. This is designed to be used in conjunction with `virtual_network_link_default_virtual_networks` and `virtual_network_link_additional_virtual_networks` to link specific zones to other virtual networks.

This is merged with the `virtual_network_link_default_virtual_networks` and `virtual_network_link_additional_virtual_networks` after `virtual_network_link_overrides_by_zone` and `virtual_network_link_overrides_by_virtual_network` has been applied to create the final set of virtual network links for each private link private DNS zone.

The first key is the the private link private DNS zone map key from the `private_link_private_dns_zones` or `private_link_private_dns_zones_additional` variables.

The second key is an arbitrary map key for the Virtual Network Link. If this key matches a key in the `virtual_network_link_default_virtual_networks` or `virtual_network_link_additional_virtual_networks` variable, this entry will take precedence.

- `virtual_network_resource_id` - (Optional) The resource ID of the Virtual Network to link to the private link private DNS zones created to.
- `name` - (Optional) The name of the virtual network link.
- `resolution_policy` -  (Optional) The resolution policy for the Virtual Network Link. Possible values are `Default` and `NxDomainRedirect`. If not specified, the value from `virtual_network_link_overrides`, `private_link_dns_zones`, `private_link_dns_zones_additional`, or `virtual_network_link_resolution_policy_default` variable will be used in that precedence

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_default_virtual_networks" {
  type = map(object({
    virtual_network_resource_id                 = optional(string)
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of objects of Virtual Network Resource IDs to link to all the private link private DNS zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `virtual_network_resource_id` - (Optional) The resource ID of the Virtual Network to link to the private link private DNS zones created to.
- `virtual_network_link_name_template_override` - (Optional) A template to override the default name of the virtual network link. If this option is not provided, the default of `var.virtual_network_link_name_template` will be used. The template can include the following placeholders:
    - `{zone_key}` - The map key of the private link private DNS zone.
    - `{vnet_name}` - The name of the virtual network.
    - `{vnet_key}` - The map key of the virtual network link.
    - `{location}` - The location of the resource group where the private link private DNS zone is created. In the case of multi-region deployment, this may refer to the primary region only. The `vnet_name` may be better suited to identify the VNet location in such cases.
- `resolution_policy` - (Optional) The resolution policy for the Virtual Network Link. Possible values are `Default` and `NxDomainRedirect`. If not specified, the value from `virtual_network_link_overrides_by_zone`, `virtual_network_link_overrides_by_virtual_network`, `virtual_network_link_overrides`, `private_link_dns_zones`, `private_link_dns_zones_additional`, or `virtual_network_link_resolution_policy_default` variable will be used in that precedence.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_name_template" {
  type        = string
  default     = "vnet_link-$${zone_key}-$${vnet_key}"
  description = <<DESCRIPTION
A prefix to use for the names of the Virtual Network Links created. A template for the default name of the virtual network link. The template can include the following placeholders:
    - `{zone_key}` - The map key of the private link private DNS zone.
    - `{vnet_name}` - The name of the virtual network the link is associated with.
    - `{vnet_key}` - The map key of the virtual network link.
    - `{location}` - The location of the resource group where the private link private DNS zone is created. In the case of multi-region deployment, this may refer to the primary region only. The `vnet_name` may be better suited to identify the VNet location in such cases.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_overrides_by_virtual_network" {
  type = map(object({
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
    enabled                                     = optional(bool, true)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of overrides for the default Virtual Network Links applied per virtual network.

This is applied to all virtual network links, including those defined in the `virtual_network_link_default_virtual_networks`, `virtual_network_link_additional_virtual_networks`, and `virtual_network_link_by_zone`.

The precedence order of overrides is `virtual_network_link_override_by_virtual_network`, `virtual_network_link_override_by_zone`, and then `virtual_network_link_overrides_by_zone_and_virtual_network`.

The key is the Virtual Network Link map key from the `virtual_network_link_default_virtual_networks` and `virtual_network_link_additional_virtual_networks`, or the second map key from `virtual_network_link_by_zone_and_virtual_network`.

- `virtual_network_link_name_template_override` - (Optional) A template to override the default name of the virtual network link. The template can include the following placeholders:
    - `{zone_key}` - The map key of the private link private DNS zone.
    - `{vnet_name}` - The name of the virtual network.
    - `{vnet_key}` - The map key of the virtual network link.
    - `{location}` - The location of the resource group where the private link private DNS zone is created. In the case of multi-region deployment, this may refer to the primary region only. The `vnet_name` may be better suited to identify the VNet location in such cases.
- `resolution_policy` - (Optional) The resolution policy for the Virtual Network Link. Possible values are `Default` and `NxDomainRedirect`.
- `enabled` - (Optional) Whether the virtual network link is enabled. Defaults to `true`.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_overrides_by_zone" {
  type = map(object({
    virtual_network_link_name_template_override = optional(string)
    resolution_policy                           = optional(string)
    enabled                                     = optional(bool, true)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of overrides for the default Virtual Network Links applied per DNS zone.

This is applied to all virtual network links, including those defined in the `virtual_network_link_default_virtual_networks`, `virtual_network_link_additional_virtual_networks`, and `virtual_network_link_by_zone`.

The precedence order of overrides is `virtual_network_link_override_by_virtual_network`, `virtual_network_link_override_by_zone`, and then `virtual_network_link_overrides_by_zone_and_virtual_network`.

The key is the the private link private DNS zone map key from the `private_link_private_dns_zones` or `private_link_private_dns_zones_additional` variables.

- `virtual_network_link_name_template_override` - (Optional) A template to override the default name of the virtual network link. The template can include the following placeholders:
    - `{zone_key}` - The map key of the private link private DNS zone.
    - `{vnet_name}` - The name of the virtual network.
    - `{vnet_key}` - The map key of the virtual network link.
    - `{location}` - The location of the resource group where the private link private DNS zone is created. In the case of multi-region deployment, this may refer to the primary region only. The `vnet_name` may be better suited to identify the VNet location in such cases.
- `resolution_policy` - (Optional) The resolution policy for the Virtual Network Link. Possible values are `Default` and `NxDomainRedirect`.
- `enabled` - (Optional) Whether the virtual network link is enabled. Defaults to `true`.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_overrides_by_zone_and_virtual_network" {
  type = map(map(object({
    name              = optional(string)
    resolution_policy = optional(string)
    enabled           = optional(bool, true)
  })))
  default     = {}
  description = <<DESCRIPTION
A map of overrides for the default Virtual Network Links applied per DNS zone and Virtual Network.

This is applied to all virtual network links, including those defined in the `virtual_network_link_default_virtual_networks`, `virtual_network_link_additional_virtual_networks`, and `virtual_network_link_by_zone`.

The precedence order of overrides is `virtual_network_link_override_by_virtual_network`, `virtual_network_link_override_by_zone`, and then `virtual_network_link_overrides_by_zone_and_virtual_network`.

The first key is the the private link private DNS zone map key from the `private_link_private_dns_zones` or `private_link_private_dns_zones_additional` variables.

The second key is the Virtual Network Link map key from `virtual_network_link_default_virtual_networks` and `virtual_network_link_additional_virtual_networks`, or the second map key from `virtual_network_link_by_zone_and_virtual_network`.

- `name` - (Optional) The name of the virtual network link to override the default name.
- `resolution_policy` - (Optional) The resolution policy for the Virtual Network Link. Possible value are `Default` and `NxDomainRedirect`.
- `enabled` - (Optional) Whether the virtual network link is enabled. Defaults to `true`.

DESCRIPTION
  nullable    = false
}

variable "virtual_network_link_resolution_policy_default" {
  type        = string
  default     = "Default"
  description = <<DESCRIPTION
The default resolution policy for the Virtual Network Links created. Possible values are `Default` and `NxDomainRedirect`. If a specific private link private DNS zone requires a different resolution policy, this can be overridden by assigning the `resolution_policy` attribute in the specific private link private DNS zone's declaration.
DESCRIPTION
  nullable    = false

  validation {
    condition     = contains(["Default", "NxDomainRedirect"], var.virtual_network_link_resolution_policy_default)
    error_message = "The virtual_network_link_resolution_policy_default must be one of: 'Default', or 'NxDomainRedirect'."
  }
}
