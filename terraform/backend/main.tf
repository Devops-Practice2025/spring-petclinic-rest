resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstateacct020526"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  access_tier = "Cool"

  lifecycle { 
    prevent_destroy = true
    ignore_changes = [tags]
  
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  lifecycle { prevent_destroy = true }
}



output "backend_storage_account" {
  value = azurerm_storage_account.tfstate.name
}
output "backend_container" {
  value = azurerm_storage_container.tfstate.name
}

