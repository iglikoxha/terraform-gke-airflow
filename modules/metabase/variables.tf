variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "cluster_location" {
  type        = string
  description = "Cluster location"
}

variable "db_type" {
  type = string
  # mysql or postgres
  description = "Database type"
  default     = ""
}

variable "db_host" {
  type        = string
  description = "Database host"
  default     = ""
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = ""
}

variable "db_user" {
  type        = string
  description = "Database user"
  default     = ""
}

variable "db_password" {
  type        = string
  description = "Database password"
  default     = ""
}

variable "db_port" {
  type        = string
  description = "Database port"
  default     = ""
}

variable "metabase_helm_chart_version" {
  type        = string
  description = "Metabase helm chart version"
  default     = "2.1.4"
}

variable "metabase_namespace" {
  type        = string
  description = "Metabase namespace"
  default     = "metabase"
}

variable "enabled" {
  type        = bool
  description = "Whether to deploy metabase"
  default     = false
}
