#!/bin/bash
set -e

echo "Deleting wr_m_sample..."

PGPASSWORD=$DB_PASSWORD psql \
  -h $DB_HOST \
  -p $DB_PORT \
  -U $DB_USER \
  -d $DB_NAME \
  -f /app/sql/delete_wr_m_sample.sql

echo "Downloading m_sample.csv from Cloud Storage..."
gsutil cp gs://$GCS_BUCKET/m_sample.csv /tmp/m_sample.csv

echo "Loading CSV into wr_m_sample..."

PGPASSWORD=$DB_PASSWORD psql \
  -h $DB_HOST \
  -p $DB_PORT \
  -U $DB_USER \
  -d $DB_NAME \
  -c "\COPY wr_m_sample FROM '/tmp/m_sample.csv' WITH (FORMAT csv, HEADER true)"

echo "Job completed successfully!"
