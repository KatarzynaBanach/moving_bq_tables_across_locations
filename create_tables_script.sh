bq query \
--use_legacy_sql=false \
--location='US' \
"""CREATE OR REPLACE TABLE \`$PROJECT_ID.dataset_us.table_1\`
AS
SELECT 1 AS id, 'Kasia' AS name;"""

bq query \
--use_legacy_sql=false \
--location='US' \
"""CREATE OR REPLACE TABLE \`$PROJECT_ID.dataset_us.table_2\`
AS
SELECT 345345 AS order_id, 'Bowl' AS product;"""

bq query \
--use_legacy_sql=false \
--location='US' \
"""CREATE OR REPLACE TABLE \`$PROJECT_ID.dataset_us.table_3\`
AS
SELECT '2024-01-01' AS _date, 7.55345 AS sales;"""