terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  project = "arctic-thought-459809-d1"
  region  = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "arctic-thought-459809-d1-terraform-bucket"
  location      = "US"
  force_destroy = true
  versioning { enabled = true }
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# ---- BigQuery Dataset ----
resource "google_bigquery_dataset" "green_taxi_dataset" {
  dataset_id = "green_taxi_nov2025"   # name of your dataset
  project    = "arctic-thought-459809-d1"
  location   = "US"
}