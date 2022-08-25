resource "google_container_cluster" "primary" {
  name     = "${var.resource_prefix}${var.cluster_name}${var.resource_suffix}"
  location = var.zone
  network  = var.network_name
  # Subnet region defaults to the region configured in the provider.
  subnetwork = var.subnetwork_name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = var.cluster_initial_node_count

  # For connecting using private IP, the GKE cluster must be VPC-native 
  # and peered with the same VPC network as the Cloud SQL instance.
  networking_mode = "VPC_NATIVE"

  # VPC_NATIVE enables IP aliasing, and requires the 
  # ip_allocation_policy block to be defined.
  ip_allocation_policy {}
}

data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

# It is recommended that node pools be created and managed as separate resources.
# Node pools defined directly in the google_container_cluster resource cannot 
# be removed without re-creating the cluster.
resource "google_container_node_pool" "primary-node-pool" {
  name       = "${var.resource_prefix}${var.node_pool_name}${var.resource_suffix}"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_pool_node_count

  node_config {
    machine_type = var.node_pool_machine_type
  }
}

