data "google_compute_subnetwork" "subnet" {
  project = var.project_id
  name    = var.subnetwork_name
  region  = var.region
}

resource "google_container_cluster" "primary" {
  project    = var.project_id
  name       = "${var.resource_prefix}${var.cluster_name}${var.resource_suffix}"
  location   = var.regional_cluster ? var.region : var.zone
  network    = var.network_name
  subnetwork = data.google_compute_subnetwork.subnet.self_link

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
  project  = var.project_id
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

# It is recommended that node pools be created and managed as separate resources.
# Node pools defined directly in the google_container_cluster resource cannot 
# be removed without re-creating the cluster.
resource "google_container_node_pool" "primary-node-pool" {
  project    = var.project_id
  name       = "${var.resource_prefix}${var.node_pool_name}${var.resource_suffix}"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_pool_node_count

  node_config {
    machine_type = var.node_pool_machine_type
  }
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

resource "helm_release" "airflow" {
  name             = "airflow"
  repository       = "https://airflow.apache.org"
  chart            = "airflow"
  namespace        = var.airflow_namespace
  version          = var.airflow_helm_chart_version
  create_namespace = true
  wait             = false

  values = [
    "${file("${var.values_path}")}"
  ]

  set {
    name  = "defaultAirflowTag"
    value = var.airflow_default_tag
  }

  set {
    name  = "airflowVersion"
    value = var.airflow_version
  }

  set {
    name  = "images.airflow.repository"
    value = var.images_airflow_repository
  }

  set {
    name  = "images.airflow.tag"
    value = var.images_airflow_tag
  }

  set {
    name  = "executor"
    value = var.airflow_executor
  }

  # set {
  #  name  = "webserver.service.type"
  #  value = "LoadBalancer"
  # }

  set {
    name  = "ingress.web.enabled"
    value = true
  }

  set {
    name  = "ingress.web.path"
    value = "/airflow"
  }

  # There is a gotcha that needs to be addressed if you are using the Helm chart:
  # decrease the webserver.readinessProbe.timeoutSeconds from the default 30 to 5 
  # or change the check-interval value from 5 to 30.

  # Because the default checkIntervalSec value for a health check on GCP is only 5 seconds
  # while the default on the Airflow Helm chart is 30, this results in a value error 1 that 
  # will prevent your Ingress (and subsequently, the GCP load balancer) from being created.

  set {
    name  = "webserver.readinessProbe.timeoutSeconds"
    value = 5
  }

  set {
    name  = "dags.gitSync.enabled"
    value = var.airflow_gitsync_enabled
  }

  set {
    name  = "dags.gitSync.repo"
    value = var.airflow_gitsync_repo
  }

  set {
    name  = "dags.gitSync.branch"
    value = var.airflow_gitsync_branch
  }

  set {
    name  = "dags.gitSync.subPath"
    value = var.airflow_gitsync_subpath
  }

  set {
    name  = "dags.gitSync.sshKeySecret"
    value = "airflow-ssh-secret"
  }

  set {
    name  = "extraSecrets.airflow-ssh-secret.data"
    value = "gitSshKey: ${var.airflow_ssh_secret}"
  }

  set {
    name  = "data.metadataConnection.user"
    value = var.db_user
  }

  set {
    name  = "data.metadataConnection.pass"
    value = var.db_password
  }

  set {
    name  = "data.metadataConnection.host"
    value = var.db_host
  }

  set {
    name  = "data.metadataConnection.db"
    value = var.db_name
  }

  set {
    name  = "data.metadataConnection.port"
    value = var.db_port
  }

  set {
    name  = "postgresql.enabled"
    value = var.db_host == ""
  }

  depends_on = [google_container_node_pool.primary-node-pool]
}

module "metabase" {
  project_id = var.project_id
  source     = "./modules/metabase"

  enabled     = var.metabase_enabled
  db_type     = var.db_host == "" ? "" : "postgres"
  db_host     = var.db_host == "" ? "" : var.db_host
  db_name     = var.db_host == "" ? "" : var.db_name
  db_user     = var.db_host == "" ? "" : var.db_user
  db_password = var.db_host == "" ? "" : var.db_password
  db_port     = var.db_host == "" ? "" : var.db_port

  cluster_name     = google_container_cluster.primary.name
  cluster_location = google_container_cluster.primary.location
}
