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

variable "cluster_name" {
  type        = string
  description = "GKE cluster name"
  default     = "cluster"
}

variable "cluster_initial_node_count" {
  type        = number
  description = "Cluster initial node count"
  default     = 1
}

variable "node_pool_name" {
  type        = string
  description = "Node pool name"
  default     = "node-pool"
}

variable "node_pool_machine_type" {
  type        = string
  description = "Node pool machine type"
}

variable "node_pool_node_count" {
  type        = number
  description = "Node pool node count"
  default     = 1
}

variable "airflow_helm_chart_version" {
  type        = string
  description = "Airflow helm chart version"
  default     = "1.6.0"
}

variable "airflow_namespace" {
  type        = string
  description = "Airflow namespace"
  default     = "airflow"
}

variable "airflow_default_tag" {
  type        = string
  description = "Airflow default tag"
  default     = "2.3.3"
}

variable "airflow_version" {
  type        = string
  description = "Airflow version"
  default     = "2.3.3"
}

variable "airflow_executor" {
  type        = string
  description = "Airflow executor"
  default     = "KubernetesExecutor"
}

variable "airflow_gitsync_enabled" {
  type        = string
  description = "Whether Git-Sync should be enabled for mounting dags"
  default     = false
}

variable "airflow_gitsync_repo" {
  type        = string
  description = "Private repository SSH address"
  default     = ""
}

variable "airflow_gitsync_branch" {
  type        = string
  description = "Repository branch"
  default     = ""
}

variable "airflow_gitsync_subpath" {
  type        = string
  description = "Path of dags in repository"
  default     = ""
}

variable "airflow_ssh_secret" {
  type        = string
  description = "Base64 encrypted private key"

  # Base64 encoded space
  default = "IA=="
}
