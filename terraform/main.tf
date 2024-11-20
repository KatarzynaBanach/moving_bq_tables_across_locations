terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "gifted-object-406811"
  region  = "us-central1"
  zone    = "us-central1-a"
}


# TRY:

resource "google_storage_bucket" "bucket" {
  for_each  = toset( ["EU", "US"] )
  name      = "bucket_bq_data_${each.value}"

  location  = each.value
  storage_class = "STANDARD"
}

resource "google_bigquery_dataset" "dataset" {
  for_each  = toset( ["EU", "US"] )
  dataset_id      = "dataset${each.value}"
  location        = each.value
}

resource "google_storage_bucket" "bucket_for_state" {
  name        = "qwiklabs-gcp-00-081e872498d7"
  location    = "US" # Replace with EU for Europe region
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "qwiklabs-gcp-00-081e872498d7"
    prefix  = "terraform/state"
  }
}

# potem w konsoli:

# terraform init -migrate-state



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