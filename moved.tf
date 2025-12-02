# DNS Zones
moved {
  from = module.avm_res_network_privatednszone["azure_container_apps"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_container_apps"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_ml"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_ml"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_ml_notebooks"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_ml_notebooks"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_ai_cog_svcs"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_ai_cog_svcs"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_ai_oai"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_ai_oai"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_ai_services"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_ai_services"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_bot_svc_bot"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_bot_svc_bot"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_bot_svc_token"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_bot_svc_token"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_service_hub"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_service_hub"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_data_factory"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_data_factory"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_data_factory_portal"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_data_factory_portal"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_hdinsight"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_hdinsight"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_data_explorer"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_data_explorer"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_storage_blob"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_storage_blob"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_storage_queue"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_storage_queue"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_storage_table"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_storage_table"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_storage_file"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_storage_file"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_storage_web"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_storage_web"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_data_lake_gen2"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_data_lake_gen2"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_file_sync"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_file_sync"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_power_bi_tenant_analysis"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_power_bi_dedicated"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_power_bi_dedicated"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_power_bi_power_query"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_power_bi_power_query"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_databricks_ui_api"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_databricks_ui_api"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_batch"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_batch"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_avd_global"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_avd_global"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_avd_feed_mgmt"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_aks_mgmt"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_aks_mgmt"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_acr_registry"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_acr_registry"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_sql_server"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_sql_server"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_sql"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_sql"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_mongo"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_mongo_vcore"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_cassandra"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_gremlin"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_table"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_table"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_analytical"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_cosmos_db_postgres"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_maria_db_server"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_maria_db_server"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_postgres_sql_server"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_postgres_sql_server"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_mysql_db_server"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_mysql_db_server"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_redis_cache"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_redis_cache"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_redis_enterprise"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_redis_enterprise"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_arc_hybrid_compute"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_arc_guest_configuration"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_arc_guest_configuration"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_arc_kubernetes"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_arc_kubernetes"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_event_grid"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_event_grid"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_api_management"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_api_management"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_healthcare"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_healthcare"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_healthcare_dicom"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_healthcare_dicom"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_iot_hub"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_iot_hub"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_iot_hub_provisioning"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_iot_hub_update"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_iot_hub_update"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_iot_central"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_iot_central"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_digital_twins"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_digital_twins"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_media_services_delivery"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_media_services_delivery"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_automation"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_automation"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_backup"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_backup"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_site_recovery"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_site_recovery"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_monitor"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_monitor"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_log_analytics"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_log_analytics"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_log_analytics_data"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_log_analytics_data"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_monitor_agent"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_monitor_agent"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_managed_prometheus"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_managed_prometheus"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_purview_account"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_purview_account"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_purview_studio"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_purview_studio"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_migration_service"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_migration_service"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_grafana"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_grafana"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_key_vault"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_key_vault"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_managed_hsm"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_managed_hsm"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_app_configuration"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_app_configuration"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_attestation"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_attestation"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_search"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_search"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_app_service"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_app_service"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_signalr_service"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_signalr_service"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_synapse"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_synapse"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_synapse_sql"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_synapse_sql"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_synapse_dev"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_synapse_dev"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_web_pubsub"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_web_pubsub"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_1"].azapi_resource.private_dns_zone
}
moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_2"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_3"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_4"].azapi_resource.private_dns_zone
}

moved {
  from = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].azurerm_private_dns_zone.this
  to   = module.avm_res_network_privatednszone["azure_static_web_apps_partitioned_5"].azapi_resource.private_dns_zone
}
