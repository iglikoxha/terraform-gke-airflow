output "endpoint" {
  value = module.gke-airflow.endpoint
}

output "private_ip_address" {
  value = module.sql-postgres.private_ip_address
}
