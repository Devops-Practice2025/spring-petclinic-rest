variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west4"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "europe-west4-c"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "ing-sandbox-cluster"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "sandbox"
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "disk_size_gb" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 50
}

variable "node_version" {
  description = "Kubernetes version for nodes"
  type        = string
  default     = ""  # Empty means use cluster's default version
}