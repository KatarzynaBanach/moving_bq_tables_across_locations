terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Crete storage buckets for two locations.
resource "google_storage_bucket" "bucket" {
  for_each  = toset( var.bucket_locations )
  name      = "bq_data_${lower(each.value)}_${var.project_id}"

  location  = each.value
  storage_class = "STANDARD"
}

# Create BigQuery datasets for two locations.
resource "google_bigquery_dataset" "dataset" {
  for_each  = toset( var.dataset_locations )
  dataset_id      = "dataset_${lower(each.value)}"
  location        = each.value
}