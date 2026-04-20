# Configure the GCP Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create the GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  
  # Initial node count for the default node pool
  initial_node_count = 1
  
  # Remove default node pool to manage it separately
  remove_default_node_pool = true
  
  # Network configuration
  network    = "default"
  subnetwork = "default"
  
  # Enable basic addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  
  # Release channel for automatic upgrades
  release_channel {
    channel = "REGULAR"
  }
  
  # Enable legacy ABAC (set to false for RBAC)
  enable_legacy_abac = false
  
  # Private cluster configuration (optional - adjust based on your needs)
  # Uncomment for private cluster:
  # private_cluster_config {
  #   enable_private_nodes    = true
  #   enable_private_endpoint = false
  #   master_ipv4_cidr_block = "172.16.0.0/28"
  # }
  
  # IP allocation policy
  ip_allocation_policy {
    cluster_secondary_range_name  = ""
    services_secondary_range_name = ""
  }
}

# Separate node pool for better management
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  initial_node_count = var.node_count
  version = var.node_version
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  

  
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  
  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-standard"
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
    
    metadata = {
      disable-legacy-endpoints = "true"
    }
    
    # Preemptible nodes can reduce cost (optional)
    preemptible = false
    
    labels = {
      environment = var.environment
      managed-by  = "terraform"
    }
  }
  
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "google_artifact_registry_repository" "my_repo" {
  location      = "europe-west4" # Choose your region
  repository_id = "petclinic-repo"
  description   = "Docker repository"
  format        = "DOCKER"
}


# Get cluster credentials for kubectl
resource "null_resource" "get_credentials" {
  depends_on = [google_container_cluster.primary]
  
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}"
  }
}