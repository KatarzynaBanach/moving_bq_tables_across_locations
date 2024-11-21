#!/bin/bash

# Set variable PROJECT_ID to current GCP project.
PROJECT_ID="$(gcloud config list --format="value(core.project)")"

# Init terraform and create resources.
cd terraform
tarrform init
terraform apply -var="project_id=$PROJECT_ID"

# Yes - to documentation!

# Extract output from Terraform and transform it to map.
DATASET_IDS=$( terraform output dataset_ids_map) 
cd ..
sh helper_scripts/map_dataset.sh $DATASET_IDS

# Create tables in BQ with artificial data in dataset.
DATASET_FROM=${DATASET_IDS_MAP[US]}
sh helper_scripts/create_tables.sh $PROJECT_ID $DATASET_FROM

echo 'Resouces created.'