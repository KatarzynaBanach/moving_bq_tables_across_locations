output "dataset_id_1" {
  value = element([for ds in google_bigquery_dataset.dataset : ds.dataset_id], 0)
  description = "ID of the first dataset."
}

output "dataset_id_2" {
  value = element([for ds in google_bigquery_dataset.dataset : ds.dataset_id], 1)
  description = "ID of the second dataset."
}