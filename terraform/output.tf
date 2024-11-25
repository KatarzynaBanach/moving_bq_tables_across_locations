output "dataset_ids" {
  value = { for key, dataset in google_bigquery_dataset.dataset : key => dataset.dataset_id }
}