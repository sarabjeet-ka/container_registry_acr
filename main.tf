locals {
  flattened_user_identities = flatten([
    for k, v in var.acr_variables : [
      for id in v.user_identities : {
        acr_key              = k
        identity_name        = id.name
        resource_group_name  = id.resource_group_name
      }
    ]
  ])

  user_identity_map = {
    for identity in local.flattened_user_identities : "${identity.acr_key}_${identity.identity_name}" => {
      name                = identity.identity_name
      resource_group_name = identity.resource_group_name
    }
  }

  user_identity_ids = {
    for k, v in var.acr_variables : k => [
      for id in v.user_identities : data.azurerm_user_assigned_identity.example["${k}_${id.name}"].id
    ]
  }

  identity_configs = {
    for k, v in var.acr_variables : k => {
      type = v.use_system_assigned_identity && v.use_user_assigned_identity ? "SystemAssigned, UserAssigned" :v.use_system_assigned_identity ? "SystemAssigned" :v.use_user_assigned_identity ? "UserAssigned" : ""
      identity_ids = v.use_user_assigned_identity ? local.user_identity_ids[k] : []
    }
  }
}


data "azurerm_user_assigned_identity" "example" {
  for_each = local.user_identity_map
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_container_registry" "container_registry" {
for_each = var.acr_variables
name = each.value.container_registry_name
resource_group_name=each.value.resource_group_name_container
location = each.value.location
sku=each.value.sku
admin_enabled=each.value.admin_enabled
public_network_access_enabled=each.value.public_network_access_enabled
quarantine_policy_enabled=each.value.quarantine_policy_enabled
retention_policy_in_days=each.value.retention_policy_in_days
trust_policy_enabled=each.value.trust_policy_enabled
zone_redundancy_enabled=each.value.zone_redundancy_enabled
export_policy_enabled=each.value.export_policy_enabled
anonymous_pull_enabled=each.value.anonymous_pull_enabled
data_endpoint_enabled=each.value.data_endpoint_enabled


dynamic "identity" { 
  for_each = local.identity_configs[each.key].type != "" ? [1] : [] 
  content { 
    type = local.identity_configs[each.key].type 
  identity_ids = local.identity_configs[each.key].identity_ids 
  } 
  }
}

