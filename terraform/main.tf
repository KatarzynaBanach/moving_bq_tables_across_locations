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

resource "google_composer_environment" "composer-env-1" {
  name   = "composer-env"
  region = "us-central1"
  config {

    software_config {
      image_version = "composer-3-airflow-2"
    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    # node_config {
    #   service_account = google_service_account.test.name
    # }
  }
}
