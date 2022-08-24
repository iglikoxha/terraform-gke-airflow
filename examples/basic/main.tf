module "basic_airflow" {
  source     = "../../"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
