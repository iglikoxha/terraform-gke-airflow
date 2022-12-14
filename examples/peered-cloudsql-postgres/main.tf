module "sql-postgres" {
  source = "../../modules/peered-cloudsql-postgres"

  project_id = var.project_id
  region     = var.region

  db_name     = "airflow"
  db_user     = "airflow"
  db_password = "airflow"
}

module "gke-airflow" {
  source = "../../"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  db_host     = module.sql-postgres.private_ip_address
  db_name     = "airflow"
  db_user     = "airflow"
  db_password = "airflow"

  values_path = "../../values.yaml"
}
