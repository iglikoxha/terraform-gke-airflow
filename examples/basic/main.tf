module "basic_airflow" {
  source     = "../../"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  # Baked dags in docker local image
  images_airflow_repository = "airflow-local"
  images_airflow_tag = "latest"
}
