
# Just specify your existing resource group name
resource_group  = "testrg1"
# existing RG name

# Location will be auto-detected from the RG
# You can omit location or keep it (must match RG location)
location              = "West Europe"  # Must match your RG's location

# Other variables remain the same
aks_cluster_name      = "test-aks"
acr_name              = "testacr1604"
node_count            = 1
node_vm_size          = "Standard_D2ds_v5"
acr_sku               = "Basic"
#kv_name               = "testkv1604"

tags = {
  Environment = "dev"
  Project     = "petclinic"
  ManagedBy   = "Terraform"
}