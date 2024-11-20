PROJECT_ID="$(gcloud config list --format="value(core.project)")"
cd terraform
tarrform init
terraform apply -var="project_id=$PROJECT_ID"
# Yes