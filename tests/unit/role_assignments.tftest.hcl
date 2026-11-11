mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "random" {}

run "preserves_resource_group_role_assignment_name" {
  command = plan

  variables {
    location                       = "eastus"
    parent_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example"
    enable_telemetry               = false
    private_link_private_dns_zones = {}
    resource_group_role_assignments = {
      reader = {
        principal_id               = "11111111-1111-1111-1111-111111111111"
        role_definition_id_or_name = "Reader"
      }
      mixed_case = {
        principal_id               = "AaBbCcDd-1234-5678-90Ab-CdEf12345678"
        role_definition_id_or_name = "Mixed case role"
      }
    }
  }

  override_module {
    target = module.regions
    outputs = {
      regions_by_name_or_display_name = {
        eastus = {
          geo_code = "us"
          name     = "eastus"
        }
      }
    }
  }

  override_module {
    target = module.avm_interfaces
    outputs = {
      role_assignments_azapi = {
        reader = {
          name = "22222222-2222-2222-2222-222222222222"
          type = "Microsoft.Authorization/roleAssignments@2022-04-01"
          body = {
            properties = {
              principalId      = "11111111-1111-1111-1111-111111111111"
              roleDefinitionId = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
            }
          }
        }
        mixed_case = {
          name = "33333333-3333-3333-3333-333333333333"
          type = "Microsoft.Authorization/roleAssignments@2022-04-01"
          body = {
            properties = {
              principalId      = "AaBbCcDd-1234-5678-90Ab-CdEf12345678"
              roleDefinitionId = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/ACDD72A7-3385-48EF-BD42-F606FBA81AE7"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = azapi_resource.role_assignments["reader"].name == "efa5e915-95ac-5162-ac66-a92a0faae307"
    error_message = "The resource group role assignment name must retain the published deterministic UUID."
  }

  assert {
    condition     = azapi_resource.role_assignments["mixed_case"].name == "8dbac567-8afe-5bc3-af56-532d32cfdecc"
    error_message = "The UUID must use the exact principal and resolved role definition ID casing."
  }
  providers = {
    azapi  = azapi
    random = random
  }
}
