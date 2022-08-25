# Set Up

## Adding credentials

Supply the service account json key file to Terraform by using the environment variable \
```GOOGLE_APPLICATION_CREDENTIALS```, setting the value to the location of the file.

## Enable the following services on your GCP project:
- compute.googleapis.com
- container.googleapis.com
- sqladmin.googleapis.com
- servicenetworking.googleapis.com
- cloudresourcemanager.googleapis.com

### Why manually enable these services?
Automatically enabling GCP services with Terraform is a little flaky \
and will cause dependency errors that's why this module doesn't do it.

## A private GitHub repository for dags (Optional)
Used for mounting DAGs from a private Github repo using Git-Sync sidecar: \
https://airflow.apache.org/docs/helm-chart/stable/manage-dags-files.html

Supply the base64 encrypted private key to Terraform by using the environment \
variable ```TF_VAR_airflow_ssh_secret```.

## A GCS bucket for storing the Terraform backend (Optional) (Recommended)
Secrets such as sshKeySecret which airflow uses for Git-Sync will be
in plain text in Terraform State.
