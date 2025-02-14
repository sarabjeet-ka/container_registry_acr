acr_variables = {
"acr_1"= {
container_registry_name="myregistry24280620"
resource_group_name_container="aks-demo-rg"
location="centralindia"
sku="Premium"
admin_enabled=false
public_network_access_enabled=false
quarantine_policy_enabled=false
retention_policy_in_days=7
trust_policy_enabled=false
zone_redundancy_enabled=false
export_policy_enabled=false
anonymous_pull_enabled=false
data_endpoint_enabled=false
use_user_assigned_identity=true
use_system_assigned_identity=true
user_identities = [
    {name="useridentity", resource_group_name="aks-demo-rg"},
    {name="useridentity2", resource_group_name="selfhostedvm_group"}
]
}
}