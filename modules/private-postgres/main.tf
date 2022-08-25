data "google_compute_network" "network" {
  project = var.project_id
  name    = var.network_name
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  project       = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = data.google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  project          = var.project_id
  name             = "${var.resource_prefix}${var.db_instance_name}${var.resource_suffix}-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "POSTGRES_14"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = data.google_compute_network.network.id
    }
  }
}

resource "google_sql_user" "user" {
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  name     = var.db_user
  password = var.db_password
}

resource "google_sql_database" "instance" {
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}
