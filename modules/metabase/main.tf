data "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.cluster_location
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

resource "helm_release" "metabase" {
  count = var.enabled ? 1 : 0

  name             = "metabase"
  repository       = "https://pmint93.github.io/helm-charts"
  chart            = "metabase"
  namespace        = var.metabase_namespace
  version          = var.metabase_helm_chart_version
  create_namespace = true
  wait             = false

  set {
    name  = "database.type"
    value = var.db_type
  }

  set {
    name  = "database.host"
    value = var.db_host
  }

  set {
    name  = "database.port"
    value = var.db_port
  }

  set {
    name  = "database.dbname"
    value = var.db_name
  }

  set {
    name  = "database.username"
    value = var.db_user
  }

  set {
    name  = "database.password"
    value = var.db_password
  }

  # set {
  #  name  = "service.type"
  #  value = "LoadBalancer"
  # }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.path"
    value = "/metabase"
  }

  set {
	name = "ingress.hosts[0]"
	value = ""
  }
}
