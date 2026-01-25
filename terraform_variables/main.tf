terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

# ---- Storage Bucket ----
resource "google_storage_bucket" "demo_bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true
  storage_class = var.gcs_storage_class

  versioning { enabled = true }

  lifecycle_rule {
    condition { age = 3 }
    action    { type = "Delete" }
  }

  lifecycle_rule {
    condition { age = 1 }
    action    { type = "AbortIncompleteMultipartUpload" }
  }
}

# ---- BigQuery Dataset ----
resource "google_bigquery_dataset" "green_taxi_dataset" {
  dataset_id = var.bq_dataset_name
  project    = var.project
  location   = var.location
}
