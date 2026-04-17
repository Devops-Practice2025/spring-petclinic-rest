
# Just specify your existing resource group name
resource_group  = "nebula-sandbox-karthikeyangopal-5ae5a688"  # Your existing RG name

# Location will be auto-detected from the RG
# You can omit location or keep it (must match RG location)
location              = "West Europe"  # Must match your RG's location

# Other variables remain the same
aks_cluster_name      = "test-aks"
acr_name              = "testacr1604"
node_count            = 1
node_vm_size          = "standard_ds2_v2"
acr_sku               = "Basic"
#kv_name               = "testkv1604"

tags = {
  Environment = "dev"
  Project     = "petclinic"
  ManagedBy   = "Terraform"
}