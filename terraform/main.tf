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
  for_each  = toset( ["EU", "US"] )
  name      = "bq_data_${each.value}_${var.project_id}"

  location  = each.value
  storage_class = "STANDARD"
}

# Crete BigQuery datasets for two locations.
resource "google_bigquery_dataset" "dataset" {
  for_each  = toset( ["EU", "US"] )
  dataset_id      = "dataset_${each.value}"
  location        = each.value
}

# Create storage bucket to store terraform state file remotely. 
resource "google_storage_bucket" "bucket_for_state" {
  name        = "terraform_${var.project_id}"
  location    = "US"
  uniform_bucket_level_access = true
}

terraform {
  backend "gcs" {
    bucket  = google_storage_bucket.bucket_for_state.name
    prefix  = "terraform/state"
  }
}

# potem w konsoli:

# terraform init -migrate-state

# resource "google_composer_environment" "example_environment" {
#   name = "example-environment"

#   config {

#     software_config {
#       image_version = "composer-3-airflow-2.9.3-build.6"
#     }

#   }
# }