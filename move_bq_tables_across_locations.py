from datetime import datetime
import yaml
import logging

from airflow import DAG
from airflow import models
from airflow.providers.google.cloud.transfers.bigquery_to_gcs import BigQueryToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.operators.empty import EmptyOperator


# Set default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# Set variables
SOURCE_DATASET_NAME = models.Variable.get('SOURCE_DATASET_NAME')
DESTINATION_DATASET_NAME = models.Variable.get('DESTINATION_DATASET_NAME')
SOURCE_BUCKET_NAME = models.Variable.get('SOURCE_BUCKET_NAME')
DESTINATION_BUCKET_NAME = models.Variable.get('DESTINATION_BUCKET_NAME')

def read_tables_to_move(file_name):  # potem dać w evn

    logging.info(f'Reading list of tables from file {file_name}')

    try:
        with open(f'/home/airflow/gcs/data/{file_name}', 'r') as file:
            config = yaml.safe_load(file)
            return config['tables']
    except:
        logging.error(f'Error opening list of tables from {file_name}')


# Define the DAG
with DAG(
    dag_id='bq_move_tables_across_locations',
    default_args=default_args,
    description='A DAG moving BQ tables from US location to EU location',
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    catchup=False,  # Avoid backfilling
) as dag:
    
    tables=read_tables_to_move('config_file.yaml')  # TODO, gdzieś w zmiennych dać tą nazwę oraz wrzucenie w odpowiednie miejsce na data

    start_task = EmptyOperator(
        task_id='start'
    )

    end_task = EmptyOperator(
        task_id='end'
    )

    # Get the table list from config file.
    for table in tables:

        logging.info(f'Generating tasks for table: {table}')

        bigquery_to_gcs = BigQueryToGCSOperator(
            task_id=f"bigquery_to_gcs_{table}",
            source_project_dataset_table=f"{SOURCE_DATASET_NAME}.{table}",
            destination_cloud_storage_uris=[f"gs://{SOURCE_BUCKET_NAME}/{table}-*.avro"],
            export_format='AVRO',
        )

        gcs_to_gcs = GCSToGCSOperator(
            task_id=f'gcs_to_gcs_{table}',
            source_bucket=SOURCE_BUCKET_NAME,
            source_object=f"{table}-*.avro",
            destination_bucket=DESTINATION_BUCKET_NAME,
            destination_object=f"{table}-*.avro",
            exact_match=True,
        )

        gcp_to_bigquery = GCSToBigQueryOperator(
            task_id=f'gcp_to_bigquery_{table}',
            bucket=DESTINATION_BUCKET_NAME,
            source_objects=[f"{table}-*.avro"],
            destination_project_dataset_table=f"{DESTINATION_DATASET_NAME}.{table}",
            write_disposition="WRITE_TRUNCATE",
            autodetect=True,
            source_format="AVRO"
        )  

        start_task >> bigquery_to_gcs >> gcs_to_gcs >> gcp_to_bigquery >> end_task

