#!/bin/bash

# Set variable PROJECT_ID to current GCP project.
export PROJECT_ID="$(gcloud config list --format="value(core.project)")"

# Init terraform and create resources.

cd terraform
terraform init
terraform apply -var="project_id=$PROJECT_ID"

# Yes - to documentation!

# Extract output from Terraform and transform it to map.
export DATASET_IDS=$( terraform output dataset_ids) 
cd ..
declare -A DATASET_IDS_MAP

input=$(echo $DATASET_IDS | tr -d '{}' | tr '=' ' ' | tr -d '"')
elements=($input)

DATASET_IDS_MAP["${elements[0]}"]="${elements[1]}"
DATASET_IDS_MAP["${elements[2]}"]="${elements[3]}"

# Create tables in BQ with artificial data in dataset.

DATASET_FROM=${DATASET_IDS_MAP[US]}
sh helper_scripts/create_tables.sh $PROJECT_ID $DATASET_FROM

# echo 'Resouces created.'