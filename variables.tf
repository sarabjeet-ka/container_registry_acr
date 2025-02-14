variable "acr_variables" {
    type=map(object({
container_registry_name=string
resource_group_name_container=string
location=string
sku=string
admin_enabled=bool
public_network_access_enabled=bool
quarantine_policy_enabled=bool
retention_policy_in_days=number
trust_policy_enabled=bool
zone_redundancy_enabled=bool
export_policy_enabled=bool
anonymous_pull_enabled=bool
data_endpoint_enabled=bool
use_user_assigned_identity=bool
use_system_assigned_identity=bool
user_identities = list(object({ 
    name = string 
resource_group_name = string 
}))
    }))
 
}