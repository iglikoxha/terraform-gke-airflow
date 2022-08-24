resource "helm_release" "airflow" {
  name             = "airflow"
  repository       = "https://airflow.apache.org"
  chart            = "airflow"
  namespace        = var.airflow_namespace
  version          = var.airflow_helm_chart_version
  create_namespace = true
  wait             = false
  
  # TODO Support custom airflow docker image with baked dags

  set {
    name  = "defaultAirflowTag"
    value = var.airflow_default_tag
  }

  set {
    name  = "airflowVersion"
    value = var.airflow_version
  }

  set {
    name  = "executor"
    value = var.airflow_executor
  }

  set {
    name  = "webserver.service.type"
    value = "LoadBalancer"
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

  # TODO Postgres in Cloud SQL

  depends_on = [data.google_container_cluster.primary.endpoint]
}