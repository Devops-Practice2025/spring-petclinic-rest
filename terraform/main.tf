resource "azurerm_resource_group" "rg" {
  name = var.resource_group
  location = var.location
}
 

resource "azurerm_container_registry" "acr" {
  
  name = var.acr_name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku      = var.acr_sku
  admin_enabled = true

  }

resource "azurerm_kubernetes_cluster" "aks" {
  name = var.aks_cluster_name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "petclinic"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  
  default_node_pool {
    name = "default"
    node_count = var.node_count
    vm_size = var.node_vm_size
    vnet_subnet_id = null
    os_disk_size_gb = 40
    os_disk_type = "Managed"
    type = "VirtualMachineScaleSets"
    
  }

  identity {
    type = "SystemAssigned"
  }

    network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
      network_policy = "azure"
    }
  role_based_access_control_enabled = true
  
  tags = var.tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# resource "azurerm_key_vault" "secrets" {
#   name                        = var.kv_name
#   location                    = var.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false
#   sku_name = "standard"


#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
#   }
# }

# # Store ACR credentials in Key Vault
# resource "azurerm_key_vault_secret" "acr_username" {
#   name         = "acr-username"
#   value        = azurerm_container_registry.acr.admin_username
#   key_vault_id = azurerm_key_vault.secrets.id
# }

# resource "azurerm_key_vault_secret" "acr_password" {
#   name         = "acr-password"
#   value        = azurerm_container_registry.acr.admin_password
#   key_vault_id = azurerm_key_vault.secrets.id
# }

# resource "azurerm_key_vault_secret" "acr_login_server" {
#   name         = "acr-login-server"
#   value        = azurerm_container_registry.acr.login_server
#   key_vault_id = azurerm_key_vault.secrets.id
# }

# Data source for current Azure client
data "azurerm_client_config" "current" {}

# Output the kubeconfig
# With this:
resource "local_sensitive_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "${path.module}/kube_config"
}
