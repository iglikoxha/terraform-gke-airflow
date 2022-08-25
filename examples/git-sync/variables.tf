variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region to provision the resources"
}

variable "zone" {
  type        = string
  description = "Zone to provision the resources"
}

variable "airflow_ssh_secret" {
  type        = string
  description = "Base64 encrypted private key"

  # Base64 encoded space
  default = "IA=="
}
