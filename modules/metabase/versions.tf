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
