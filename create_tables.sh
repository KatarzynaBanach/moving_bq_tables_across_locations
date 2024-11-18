bq query \
--use_legacy_sql=false \
--location='US' \
"CREATE OR REPLACE TABLE \`gifted-object-406811.dataset_us.table_1\` AS SELECT 1 AS id, 'Kasia' AS name;"

bq query \
--use_legacy_sql=false \
--location='US' \
"CREATE OR REPLACE TABLE \`gifted-object-406811.dataset_us.table_2\` AS SELECT 2 AS id, 'Adam' AS name;"

bq query \
--use_legacy_sql=false \
--location='US' \
"CREATE OR REPLACE TABLE \`gifted-object-406811.dataset_us.table_3\` AS SELECT 3 AS id, 'Marcin' AS name;"
