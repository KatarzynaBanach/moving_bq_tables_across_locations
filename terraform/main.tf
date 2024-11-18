provider "google" {
  project = "gifted-object-406811"
  region  = "us-central1"
}

resource "google_storage_bucket" "us_bucket" {
  name     = "bucket_us_bq_data"
  location = "US"
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "eu_bucket" {
  name     = "bucket_eu_bq_data"
  location = "EU"
  storage_class = "STANDARD"
}

resource "google_bigquery_dataset" "dataset_us" {
  dataset_id                  = "dataset_us"
  location                    = "US"
}

resource "google_bigquery_dataset" "dataset_eu" {
  dataset_id                  = "dataset_eu"
  location                    = "EU"
}

resource "google_composer_environment" "example_environment" {
  name = "example-environment"

  config {

    software_config {
      image_version = "composer-3-airflow-2.9.3-build.6"
    }

  }
}