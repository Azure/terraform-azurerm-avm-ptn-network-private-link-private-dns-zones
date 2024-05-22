variable "resoruce_group_creation_enabled" {
  type        = bool
  default     = true
  description = "This variable controls whether or not the resource group should be created. If set to false, the resource group must be created elsewhere and the resource group name must be provided to the module. If set to true, the resource group will be created by the module using the name provided in `resource_group_name`."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "private_link_private_dns_zones" {
  type = set(string)
  default = [
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.directline.botframework.com",
    "privatelink.token.botframework.com",
    "privatelink.servicebus.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.azurehdinsight.net",
    "privatelink.{regionName}.kusto.windows.net",
    "privatelink.blob.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.analysis.windows.net",
    "privatelink.pbidedicated.windows.net",
    "privatelink.tip1.powerquery.microsoft.com",
    "privatelink.azuredatabricks.net",
    "{regionName}.privatelink.batch.azure.com",
    "{regionName}.service.privatelink.batch.azure.com",
    "privatelink-global.wvd.microsoft.com",
    "privatelink.wvd.microsoft.com",
    "privatelink.wvd.microsoft.com",
    "privatelink.{regionName}.azmk8s.io",
    "privatelink.azurecr.io",
    "{regionName}.data.privatelink.azurecr.io",
    "privatelink.database.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.analytics.cosmos.azure.com",
    "privatelink.postgres.cosmos.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    "privatelink.database.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.analytics.cosmos.azure.com",
    "privatelink.postgres.cosmos.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    "privatelink.his.arc.azure.com",
    "privatelink.guestconfiguration.azure.com",
    "privatelink.dp.kubernetesconfiguration.azure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.azure-api.net",
    "privatelink.workspace.azurehealthcareapis.com",
    "privatelink.fhir.azurehealthcareapis.com",
    "privatelink.dicom.azurehealthcareapis.com",
    "privatelink.azure-devices.net",
    "privatelink.servicebus.windows.net1",
    "privatelink.azure-devices-provisioning.net",
    "privatelink.api.adu.microsoft.com",
    "privatelink.azureiotcentral.com",
    "privatelink.digitaltwins.azure.net",
    "privatelink.media.azure.net",
    "privatelink.azure-automation.net",
    "privatelink.{regionCode}.backup.windowsazure.com",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.prod.migration.windowsazure.com",
    "privatelink.prod.migration.windowsazure.com",
    "privatelink.azure.com",
    "privatelink.grafana.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.managedhsm.azure.net",
    "privatelink.azconfig.io",
    "privatelink.attest.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.web.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.afs.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.search.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azurewebsites.net",
    "scm.privatelink.azurewebsites.net",
    "privatelink.service.signalr.net",
    "privatelink.azurestaticapps.net",
    "privatelink.servicebus.windows.net"
  ]
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

DESCRIPTION
  nullable    = false
}

variable "virtual_network_resource_ids_to_link_to" {
  type        = set(string)
  description = "A set of Virtual Network Resource IDs to link to the Private Link Private DNS Zones created."
  default = []
  nullable    = false  
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on each of the Private Link Private DNS Zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION  
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
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
}

variable "location" {
  type        = string
  nullable    = false
  description = "Azure region where the each of the Private Link Private DNS Zones created and Resource Group, if created, will be deployed."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for each of the Private Link Private DNS Zones created and Resource Group, if created. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "private_link_dns_zones_role_assignments" {
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
A map of role assignments to create on each of the Private Link Private DNS Zones created. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
A map of role assignments to create on the Resource Group, if `resoruce_group_creation_enabled` is set to `true`. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
