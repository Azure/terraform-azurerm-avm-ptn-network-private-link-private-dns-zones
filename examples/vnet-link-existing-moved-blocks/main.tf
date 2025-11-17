terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.9.2"
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this_1" {
  location            = azurerm_resource_group.this.location
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "this_2" {
  location            = azurerm_resource_group.this.location
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.2.0/24"]
}

module "test" {
  source = "../../"

  location         = azurerm_resource_group.this.location
  parent_id        = azurerm_resource_group.this.id
  enable_telemetry = var.enable_telemetry
  private_link_private_dns_zones_additional = {
    example_zone_1 = {
      zone_name                              = "{regionCode}.example.com"
      private_dns_zone_supports_private_link = false
    }
    example_zone_2 = {
      zone_name                              = "{customIterator}.example.com"
      private_dns_zone_supports_private_link = false
      custom_iterator = {
        replacement_placeholder = "customIterator"
        replacement_values = {
          custom1 = "custom1"
          custom2 = "custom2"
        }
      }
    }
  }
  virtual_network_links_default = {
    "vnet1" = {
      virtual_network_resource_id                 = azurerm_virtual_network.this_1.id
      virtual_network_link_name_template_override = "$${vnet_name}-link-$${zone_key}"
      resolution_policy                           = "NxDomainRedirect"
    }
    "vnet2" = {
      virtual_network_resource_id                 = azurerm_virtual_network.this_2.id
      virtual_network_link_name_template_override = "$${vnet_key}-link"
      resolution_policy                           = "Default"
    }
  }
}

# Moved block examples based on above declaration. Use as starting point for your own migrations/upgrades to the latest version of the module using the azapi provider.
## Private DNS Zones - only needed as these are custom DNS zones (e.g. not the default value of the variable `private_link_private_dns_zones`, as these are handled by the module)
moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].azapi_resource.private_dns_zone
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].azurerm_private_dns_zone.this
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].azapi_resource.private_dns_zone
}

## vNet Links
moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_1"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom1"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["example_zone_2_custom2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

### Default Private DNS Zones vNet Links
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_container_apps"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_container_apps"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_container_apps"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_container_apps"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ml"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ml"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ml"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ml"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ml_notebooks"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ml_notebooks"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ml_notebooks"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ml_notebooks"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_cog_svcs"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_cog_svcs"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_cog_svcs"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_cog_svcs"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_oai"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_oai"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_oai"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_oai"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_services"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_services"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_ai_services"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_ai_services"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_bot_svc_bot"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_bot_svc_bot"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_bot_svc_bot"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_bot_svc_bot"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_bot_svc_token"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_bot_svc_token"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_bot_svc_token"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_bot_svc_token"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_service_hub"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_service_hub"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_service_hub"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_service_hub"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_factory"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_factory"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_factory"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_factory"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_factory_portal"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_factory_portal"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_factory_portal"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_factory_portal"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_hdinsight"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_hdinsight"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_hdinsight"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_hdinsight"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_explorer"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_explorer"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_explorer"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_explorer"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_blob"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_blob"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_blob"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_blob"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_queue"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_queue"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_queue"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_queue"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_table"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_table"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_table"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_table"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_file"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_file"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_file"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_file"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_web"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_web"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_storage_web"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_storage_web"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_lake_gen2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_lake_gen2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_data_lake_gen2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_data_lake_gen2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_file_sync"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_file_sync"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_file_sync"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_file_sync"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_dedicated"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_dedicated"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_dedicated"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_dedicated"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_power_query"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_power_query"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_power_bi_power_query"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_power_bi_power_query"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_databricks_ui_api"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_databricks_ui_api"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_databricks_ui_api"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_databricks_ui_api"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_batch"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_batch"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_batch"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_batch"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_avd_global"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_avd_global"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_avd_global"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_avd_global"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_aks_mgmt"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_aks_mgmt"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_aks_mgmt"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_aks_mgmt"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_acr_registry"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_acr_registry"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_acr_registry"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_acr_registry"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_sql_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_sql_server"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_sql_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_sql_server"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_sql"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_sql"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_sql"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_sql"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_table"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_table"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_table"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_table"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_maria_db_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_maria_db_server"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_maria_db_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_maria_db_server"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_postgres_sql_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_postgres_sql_server"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_postgres_sql_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_postgres_sql_server"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_mysql_db_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_mysql_db_server"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_mysql_db_server"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_mysql_db_server"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_redis_cache"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_redis_cache"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_redis_cache"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_redis_cache"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_redis_enterprise"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_redis_enterprise"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_redis_enterprise"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_redis_enterprise"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_guest_configuration"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_guest_configuration"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_guest_configuration"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_guest_configuration"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_kubernetes"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_kubernetes"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_arc_kubernetes"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_arc_kubernetes"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_event_grid"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_event_grid"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_event_grid"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_event_grid"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_api_management"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_api_management"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_api_management"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_api_management"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_workspaces"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_workspaces"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_workspaces"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_workspaces"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_fhir"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_fhir"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_fhir"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_fhir"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_dicom"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_dicom"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_healthcare_dicom"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_healthcare_dicom"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub_update"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub_update"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_hub_update"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_hub_update"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_central"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_central"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_iot_central"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_iot_central"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_digital_twins"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_digital_twins"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_digital_twins"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_digital_twins"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_media_services_delivery"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_media_services_delivery"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_media_services_delivery"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_media_services_delivery"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_automation"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_automation"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_automation"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_automation"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_backup"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_backup"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_backup"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_backup"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_site_recovery"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_site_recovery"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_site_recovery"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_site_recovery"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_monitor"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_monitor"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_monitor"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_monitor"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_log_analytics"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_log_analytics"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_log_analytics"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_log_analytics"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_log_analytics_data"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_log_analytics_data"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_log_analytics_data"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_log_analytics_data"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_monitor_agent"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_monitor_agent"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_monitor_agent"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_monitor_agent"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_managed_prometheus"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_managed_prometheus"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_managed_prometheus"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_managed_prometheus"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_purview_account"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_purview_account"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_purview_account"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_purview_account"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_purview_studio"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_purview_studio"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_purview_studio"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_purview_studio"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_migration_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_migration_service"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_migration_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_migration_service"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_grafana"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_grafana"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_grafana"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_grafana"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_key_vault"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_key_vault"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_key_vault"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_key_vault"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_managed_hsm"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_managed_hsm"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_managed_hsm"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_managed_hsm"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_app_configuration"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_app_configuration"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_app_configuration"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_app_configuration"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_attestation"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_attestation"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_attestation"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_attestation"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_search"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_search"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_search"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_search"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_app_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_app_service"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_app_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_app_service"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_signalr_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_signalr_service"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_signalr_service"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_signalr_service"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

# Iterator-expanded partitioned Static Web Apps zones
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse_sql"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse_sql"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse_sql"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse_sql"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse_dev"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse_dev"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_synapse_dev"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_synapse_dev"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.test.module.avm_res_network_privatednszone["azure_web_pubsub"].azurerm_private_dns_zone_virtual_network_link.this["vnet1"]
  to   = module.test.module.avm_res_network_privatednszone["azure_web_pubsub"].module.virtual_network_links["vnet1"].azapi_resource.private_dns_zone_network_link
}
moved {
  from = module.test.module.avm_res_network_privatednszone["azure_web_pubsub"].azurerm_private_dns_zone_virtual_network_link.this["vnet2"]
  to   = module.test.module.avm_res_network_privatednszone["azure_web_pubsub"].module.virtual_network_links["vnet2"].azapi_resource.private_dns_zone_network_link
}
