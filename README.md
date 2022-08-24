# Set Up

## Enable the following services
- compute.googleapis.com
- container.googleapis.com
- sqladmin.googleapis.com
- servicenetworking.googleapis.com

### Why manually enable these services?
Automatically enabling GCP services with Terraform is \
a little flaky and will cause dependency errors 
that's why this module doesn't do it.

## A private GitHub repository for dags (Optional)
Used for mounting DAGs from a private Github repo using Git-Sync sidecar: \
https://airflow.apache.org/docs/helm-chart/stable/manage-dags-files.html

Make sure to set the base64 encrypted private key as an environment variable \
named: ```TF_VAR_airflow_ssh-secret``` so that Terraform can read it.

## A GCS bucket for storing the Terraform backend (Optional) (Recommended)
Secrets such as sshKeySecret which airflow uses for Git-Sync will be
in plain text in Terraform State.
