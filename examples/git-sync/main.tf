module "gitsync_airflow" {
  source     = "../../"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  airflow_gitsync_enabled = true
  airflow_gitsync_repo    = "git@github.com:data-max-hq/example-dags.git"
  airflow_gitsync_subpath = "dags"
  airflow_ssh_secret      = var.airflow_ssh_secret
}
