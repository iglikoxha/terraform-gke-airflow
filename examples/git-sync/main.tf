module "gitsync_airflow" {
  source     = "../../"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  airflow_gitsync_enabled = true
  airflow_gitsync_repo    = "git@github.com:data-max-hq/example-dags.git"
  airflow_gitsync_subpath = "dags"
  
  # Supply the base64 encrypted private key to Terraform by using the environment 
  # variable TF_VAR_airflow_ssh_secret.
  airflow_ssh_secret      = var.airflow_ssh_secret
}
