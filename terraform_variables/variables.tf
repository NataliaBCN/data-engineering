variable "credentials" {
  description = "Path to your Service Account JSON file"
  default     = "./keys/my-creds.json"  # relative to main.tf
}

variable "project" {
  description = "GCP Project ID"
  default     = "arctic-thought-459809-d1"
}

variable "region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "location" {
  description = "GCP location for bucket and BigQuery dataset"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  default     = "green_taxi_nov2025"
}

variable "gcs_bucket_name" {
  description = "Google Cloud Storage bucket name"
  default     = "arctic-thought-459809-d1-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "Storage class for GCS bucket"
  default     = "STANDARD"
}
