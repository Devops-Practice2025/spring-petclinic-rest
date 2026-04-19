terraform {
  backend "gcs" {
    bucket = "ing-sandbox-terraform-state"
    prefix = "gke/sandbox"
  }
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}