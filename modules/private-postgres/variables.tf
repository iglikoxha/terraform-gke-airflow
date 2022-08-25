variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region to provision the resources"
}

variable "resource_prefix" {
  type        = string
  description = "A prefix for all provisioned resource names"
  default     = ""
}

variable "resource_suffix" {
  type        = string
  description = "A suffix for all provisiond resource names"
  default     = ""
}

variable "network_name" {
  type        = string
  description = "Network name"
  default     = "default"
}

variable "db_instance_name" {
  type        = string
  description = "Database instance name"
  default     = "db"
}

variable "db_tier" {
  type        = string
  description = "Database tier"
  default     = "db-g1-small"
}

variable "db_user" {
  type        = string
  description = "Database user"
  default     = "postgres"
}

variable "db_password" {
  type        = string
  description = "Database password"
  default     = "postgres"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "postgres"
}

variable "ipv4_enabled" {
  type        = string
  description = "Whether to enable ipv4"
  default     = false
}
