# Set variable PROJECT_ID to current GCP project.
PROJECT_ID="$(gcloud config list --format="value(core.project)")"

# Init terraform and create resources.
cd terraform
tarrform init
terraform apply -var="project_id=$PROJECT_ID"

# Yes
# Create tables in BQ with artificial data in dataset.
sh create_tables_script.sh

DATASET_ID_1=$(terraform output dataset_id_1)
DATASET_ID_2=$(terraform output dataset_id_2)

