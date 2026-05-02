# Data block to read an existing resource group
resource "azurerm_resource_group" "rg" {
  name = "testrg1"
  location = "westeurope"
     }


output "rg" {
  value = data.azurerm_resource_group.rg
  
}