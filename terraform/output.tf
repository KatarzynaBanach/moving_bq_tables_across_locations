output "dataset_ids" {
  value = [for ds in google_bigquery_dataset.dataset : ds.dataset_id]
  description = "List of dataset IDs"
}