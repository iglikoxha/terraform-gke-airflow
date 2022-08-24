terraform {
  # TODO Add required version
  required_providers {
    google = {
      source = "hashicorp/google"
      # TODO Add required version
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate, )
  }
}

