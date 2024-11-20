variable "project_id" {
    type    = string
}

variable "bucket_locations" {
  description = "A list of buckets' locations that must contain exactly two locations"
  type        = list(string)

  validation {
    condition     = length(var.bucket_locations) == 2
    error_message = "The variable 'bucket_locations' must contain exactly two elements."
  }
}

variable "dataset_locations" {
  description = "A list of datasets' locations that must contain exactly two locations"
  type        = list(string)

  validation {
    condition     = length(var.dataset_locations) == 2
    error_message = "The variable 'dataset_locations' must contain exactly two elements."
  }
}
