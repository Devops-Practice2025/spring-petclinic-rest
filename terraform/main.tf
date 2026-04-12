data "azurerm_resource_group" "rg" {
  name = var.resource_group
 
}

resource "random_string" "suffix" {
  length = 6
  special = false
  upper= false
}
  

resource "azurerm_container_registry" "acr" {
  name = "${var.acr_name}${random_string.suffix.result}"
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku = "Basic"
  admin_user_enabled = true  

  }

resource "azurerm_kubernetes_cluster" "aks" {
  name = var.aks_cluster_name
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix = "${var.dns_prefix}"
  kubernetes_version = var.kubernetes_version
  default_node_pool { 
    name = "default"
    node_count = var.node_count
    vm_size = var.vm_size
    vnet_subnet_id = null
    os_disk_size_gb = 40
    os_disk_type = "Managed"
    type = "VirtualMachineScaleSets"
    node_taints = []
    identity {
      type = "SystemAssigned"
    }
  }
    network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
      network_policy = "azure"
    }
  role_based_access_control_enabled = true
  
  tags = var.tags
}

# Store ACR credentials in Key Vault
resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-username"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.secrets.id
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.secrets.id
}

resource "azurerm_key_vault_secret" "acr_login_server" {
  name         = "acr-login-server"
  value        = azurerm_container_registry.acr.login_server
  key_vault_id = azurerm_key_vault.secrets.id
}

# Data source for current Azure client
data "azurerm_client_config" "current" {}

# Output the kubeconfig
resource "local_file" "kube_config" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  filename   = "kubeconfig"
  sensitive_content = azurerm_kubernetes_cluster.aks.kube_config_raw
}


